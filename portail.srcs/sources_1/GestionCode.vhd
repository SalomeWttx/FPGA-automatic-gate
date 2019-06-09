----------------------------------------------------------------------------------
-- Company: ENSEA
-- Engineer: Alban Benmouffek, Salomé Wattiaux, Marco Guzzon 
-- 
-- Create Date: 01.03.2019 19:05:30
-- Design Name: 
-- Module Name: GestionCode - Behavioral
-- Project Name: Portail
-- Target Devices: 
-- Tool Versions: 
-- Description: gère la saisie du code, la modification du code, l'activation des différentes fonctions accessibles via le digicode.
--  Si le code est erroné moins de 10 fois de suite, il y a une temporisation de 1s avant de pouvoir réutiliser le digicode.
--  Si le code est erroné plus de 10 fois de suite, il y a une temporisation de 10s avant de pouvoir réutiliser de digicode.
--
--  Le code peut faire n'importe quelle taille, fixée à l'avance dans ce fichier (par défaut 6 chiffres de 0 à 9). Ce paramètre est défini par taille_code.
--
--  Avec un code à 6 chiffres, une attaque brute force visant à trouver le code nécessitera au plus 9999910 secondes, c'est-à-dire environ 115 jours.
--
-- Le code est stocké en clair dans des bascules du FPGA. Ce n'est pas pertinent de Hasher ce code car l'état interne du FPGA est très difficile d'accès (comparé aux fils contrôlant le moteur).
--
-- Sur le digicode, les touches de 10 à 15 correspondent à des fonctions spéciales. 
--touche      colonnes(0)     colonnes(1)     colonnes(2)     colonnes(3)
--lignes(0)       1               2               3              10
--lignes(1)       4               5               6              11
--lignes(2)       7               8               9              12
--lignes(3)       15              0              14              13
--
-- Pour utiliser une fonction spéciale, il faut cliquer sur la touche correspondante puis saisir le code.
-- La fonction choisie est décrite par la variable fonction_activee.
-- 10 : Ouvrir le Portail
-- 11 : Modifier le code
-- 15 : Annuler
-- 1 : saisir le nouveau code
-- 2 : resaisir le nouveau code
-- 0 : rien
--
-- Dependencies: 
--  Attendre (Attendre.vhd)
--  DFM (DFM.vhd)
--  TICK_Ns (TICK_Ns.vhd)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GestionCode is
    generic (
        taille_code : integer := 6;  --taille du code (nombre de chiffres)
        TempsAttenteMax : integer := 10  --nombre de secondes à attendre avant l'annulation automatique
    );
    Port ( 
        CLK : in STD_LOGIC; --Horloge
        
        --Digicode complet:
        numeroTouche : in STD_LOGIC_VECTOR (3 downto 0); --Numéro de la touhe détectée (détails dans la description)
        toucheDetectee : in STD_LOGIC; --Vaut '1' pendant une période d'horloge quand une nouvelle touche est détectée
        
        LEDdigicode : out STD_LOGIC_VECTOR(4 downto 0); --LED indiquant quelle fonction du digicode est utilisée (voir dans la description la liste des fonctions spéciales)
        retroEclairage : out STD_LOGIC; --LED allumée si le digicode est en cours d'utilisation
        
        --haut parleur
        NombreBip : out STD_LOGIC_VECTOR(2 downto 0);--Nombre de répétitions. MAX 7 REPETITIONS!
        DureeBip : out STD_LOGIC_VECTOR(6 downto 0);--Durée de chaque bip, ainsi que entre les bip, en dixieme de seconde MAX 12,7s !
        TonBip : out STD_LOGIC; -- ..=1 <=> bip aigu!
        DataBip : out STD_LOGIC; --Vaut 1 pendant 1 période d'horloge si on est en train de paramêtrer un nouveau bip (plus de détails dans HautParleur.vhd)
        
        fonction : out STD_LOGIC_VECTOR(2 downto 0) --Ordre donné au portail
        --ORDRES:
        --rien : "000"
        --changer : "011"
        --ouvrir : "001"
        --fermer : "010"
        --stop : "111"
    );
end GestionCode;

architecture Behavioral of GestionCode is
    --pour la saisie du code: (de 1 à 6 chiffres)
    type LIST is array (taille_code-1 downto 0) of integer range 0 to 9;
    signal code_saisi : LIST; --Code en train d'être saisi
    signal chiffre_saisi : integer range 0 to taille_code := 0; --Chiffre (du code) que l'on a saisi en dernier (0 si on n'a rien saisi)
    signal code : LIST; --Code enregistré en clair
    signal fonction_activee : integer range 0 to 15 := 0;--Fonction spéciale du digicode qui est en train d'être utilisée (plus de détails dans la description). Si aucune fonction n'est active : 0
    signal nombreEchec : integer range 0 to 10 := 0; --Nombre d'échecs consécutifs
    
    --Si l'utilisation est en cours
    signal utilisation : STD_LOGIC := '0'; --Vaut '1' si le digicode est en train d'être utilisé
    signal overtimed : STD_LOGIC := '0'; --Si l'utilisateur met trop de temps à appuyer sur les touches
    
    --pour changer le code :
    signal code_existe : STD_LOGIC := '0'; --Vaut '0' si le code n'a pas encore été créé (à l'allumage du FPGA)
    signal nouveau_code : LIST; --Futur code (nécessité de le stocker dans une autre variable pour pouvoir le comparer à la confirmation, sans effacer le code précédent
    
    signal fonctionDigicode : STD_LOGIC_VECTOR(2 downto 0) := "000"; 

    --Pour l'haut-parleur (ces signaux seront directement envoyés sur leus sortie respective)
    signal DataBip_s : STD_LOGIC := '0';
    signal NombreBip_s : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal DureeBip_s : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    signal TonBip_s : STD_LOGIC := '0';
    
    --pour les temporisations (temporisation = l'utilisateur s'est trompé de code donc, par sécurité, le digicode se bloque pendant un instant)
    signal temporisationClavier : STD_LOGIC := '0';  --Vaut '1' si une temporisation est en cours (1s par défaut)
    signal temporisationClavierLongue : STD_LOGIC := '0'; --Vaut '1' si une longue temporisation est en cours (10s par défaut)
    signal debutTemporisation : STD_LOGIC := '0';
    signal finTemporisation : STD_LOGIC := '0';
    signal debutTemporisationLongue : STD_LOGIC := '0';
    signal finTemporisationLongue : STD_LOGIC := '0';
    
begin
    --Pour les temporisations: (c'est Tick1s et Tick10s qui disent si la temporisation est finie ou non)
    DFM1 : entity work.DFM port map(CLK => CLK, entree => temporisationClavier, front => debutTemporisation);
    Tick1s : entity work.Tick_Ns generic map (N => 2) port map (CLK => CLK, Reset => debutTemporisation, Tick => finTemporisation);
    DFM2 : entity work.DFM port map(CLK => CLK, entree => temporisationClavierLongue, front => debutTemporisationLongue);
    Tick10s : entity work.Tick_Ns generic map (N => 20) port map (CLK => CLK, Reset => debutTemporisationLongue, Tick => finTemporisationLongue);
    
    --Pour dire si le clavier est en cours d'utilisation ou non (on compte le temps depuis le dernier signe de vie de l'utilisateur)
    attendre :
        entity work.Attendre
        generic map (
            Duree => TempsAttenteMax
        )
        port map (
            CLK => CLK,
            Attente => utilisation,
            ForceReset => toucheDetectee,
            FinAttente => overtimed
        );
    
    
    
    process(CLK) begin
        if rising_edge(CLK) then
            
            
            --GESTION DES TEMPORISATIONS
            if temporisationClavier = '1' or temporisationClavierLongue = '1' then --blocage du clavier
                DataBip_s <= '0';
                fonctionDigicode <= "000";
                chiffre_saisi <= 0;
                fonction_activee <= 0;
                --FIN TEMPORISATION
                if finTemporisationLongue = '1' then
                    temporisationClavierLongue <= '0';
                    temporisationClavier <= temporisationClavier;
                elsif finTemporisation = '1' then
                    temporisationClavier <= '0';
                    temporisationClavierLongue <= temporisationClavierLongue;
                else
                    temporisationClavierLongue <= temporisationClavierLongue;
                    temporisationClavier <= temporisationClavier;
                end if;
                    
                    
            --SI AUCUN CODE N'EXISTE (au démarrage du FPGA) -> on demande à l'utilisateur de saisir un code, pour cela on active la fonction spéciale 1 (plus de détails sur les fonctions spéciales dans la description)
            elsif code_existe = '0' and NOT(fonction_activee = 1 or fonction_activee = 2) then
                DataBip_s <= '0';
                fonctionDigicode <= "000";
                fonction_activee <= 1;
            

            --SI L'UTILISATEUR FAIT LE MORT DEPUIS TROP LONGTEMPS
            elsif overtimed = '1' and code_existe = '1' then
                DataBip_s <= '1';NombreBip_s <= "001";DureeBip_s <= "0000011";TonBip_s <= '0';  
                fonctionDigicode <= "000";
                chiffre_saisi <= 0;
                fonction_activee <= 0;
            

            --SI L'UTILISATEUR DONNE UN SIGNE DE VIE
            elsif toucheDetectee = '1' and temporisationClavier = '0' and temporisationClavierLongue = '0' then
                fonctionDigicode <= "000";
                DataBip_s <= '1';NombreBip_s <= "001";DureeBip_s <= "0000001";TonBip_s <= '1';
                if TO_INTEGER(UNSIGNED(numeroTouche)) < 10 then --Appui sur un nombre
                    --APPUI SUR UN CHIFFRE
                    code_saisi(chiffre_saisi) <= TO_INTEGER(UNSIGNED(numeroTouche));
                    chiffre_saisi <= chiffre_saisi+1;
                    fonction_activee <= fonction_activee ;
                elsif TO_INTEGER(UNSIGNED(numeroTouche)) = 15 then --Annuler
                    --APPUI SUR ANNULER       
                    if NOT(chiffre_saisi = 0 and fonction_activee = 0) then
                        DataBip_s <= '1';NombreBip_s <= "001";DureeBip_s <= "0000011";TonBip_s <= '0';           
                        chiffre_saisi <= 0;
                        fonction_activee <= 0;
                    else
                        DataBip_s <= '1';NombreBip_s <= "000";DureeBip_s <= "0000001";TonBip_s <= '0';                    
                    end if;
                else
                    --APPUI SUR UNE FONCTION SPECIALE
                    chiffre_saisi <= 0;
                    fonction_activee <= TO_INTEGER(UNSIGNED(numeroTouche));
                end if;
            
                    
            --SI L'UTILISATEUR A FINI DE SAISIR UN CODE
            elsif chiffre_saisi = taille_code then
                chiffre_saisi <= 0;
                
                if fonction_activee = 1 then
                    fonctionDigicode <= "000";
                    nouveau_code <= code_saisi;
                    --NOUVEAU CODE ENTRE UNE FOIS:OK
                    DataBip_s <= '1';NombreBip_s <= "010";DureeBip_s <= "0000010";TonBip_s <= '1';
                    fonction_activee <= 2; --(étape 1: retaper le nouveau code)
                    
                elsif fonction_activee = 2 then
                    fonctionDigicode <= "000";
                    --NOUVEAU CODE ENTRE DEUX FOIS:OK
                    if code_saisi = nouveau_code then
                        --Nouveau code ajouté
                        DataBip_s <= '1';NombreBip_s <= "110";DureeBip_s <= "0000001";TonBip_s <= '1';
                        
                        code <= nouveau_code;
                        code_existe <= '1';
                        fonction_activee <= 0;
                    else
                        --codes differents!!
                        DataBip_s <= '1';NombreBip_s <= "010";DureeBip_s <= "0000011";TonBip_s <= '0';
                        fonction_activee <= 0;
                    end if;
                    
                elsif code_saisi = code then
                    --CODE BON
                    nombreEchec <= 0;
                    
                    DataBip_s <= '1';NombreBip_s <= "010";DureeBip_s <= "0000010";TonBip_s <= '1';
                    
                    --Changer l'état du portail
                    if fonction_activee = 0 then
                        fonctionDigicode <= "011";
                        fonction_activee <= 0;
                        
                    --Ouvrir le portail
                    elsif fonction_activee = 10 then
                        fonctionDigicode <= "001";
                        fonction_activee <= 0;
                        
                    --Changer le code (étape 1: taper le nouveau code)
                    elsif fonction_activee = 11 then
                        fonctionDigicode <= "000";
                        fonction_activee <= 1;
                    else
                        fonctionDigicode <= "000";
                    end if;
                    
                --Code erroné!!
                else
                    fonctionDigicode <= "000";
                    --CODE ERRONNE
                    if nombreEchec < 10 then
                        DataBip_s <= '1';NombreBip_s <= "001";DureeBip_s <= "0001010";TonBip_s <= '0';
                        nombreEchec <= nombreEchec +1;
                        temporisationClavier <= '1';
                    else
                        DataBip_s <= '1';NombreBip_s <= "001";DureeBip_s <= "1100100";TonBip_s <= '0';
                        temporisationClavierLongue <= '1';
                        nombreEchec <= nombreEchec;
                    end if;
                end if;
                    
             
            --SI RIEN DE TOUT ÇA:
            else
                fonctionDigicode <= "000";
                DataBip_s <= '0';
                        
            end if;--Enfin le "end if" !!!
        end if;
    end process;
    
    
    --ALLUMAGE DES LED:
    process(fonction_activee) begin
        case fonction_activee is
            when 0 =>
                LEDdigicode <= "00000";
            when 1 =>
                LEDdigicode <= "00001";
            when 2 =>
                LEDdigicode <= "00001";
            when 10 =>
                LEDdigicode <= "00010";
            when 11 =>
                LEDdigicode <= "00001";
            when 12 =>
                LEDdigicode <= "00100";
            when 13 =>
                LEDdigicode <= "01000";
            when 14 =>
                LEDdigicode <= "10000";
            when others =>
                LEDdigicode <= "00000";
        end case;
    end process; 
    

    utilisation <= '0' when fonction_activee = 0 and chiffre_saisi = 0 else '1';
    
    DataBip <= DataBip_s;
    fonction <= fonctionDigicode;
    NombreBip <= NombreBip_s;
    DureeBip <= DureeBip_s;
    TonBip <= TonBip_s;
    retroEclairage <= utilisation;
      
end Behavioral;
