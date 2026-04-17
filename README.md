# Repozitár projektu z predmetu BPC-DE1 25/26L fakulty FEKT VUT

Autori:
- [Daniel Kubica](https://github.com/danielkubica) 
- [Adam Koutný](https://github.com/AdamRaccoon)

## Úloha
Create a module that smoothly changes LED brightness by generating a triangle waveform for the PWM duty cycle, simulating “inhale” and “exhale.”

# Breathing LED Controller (PWM)

Cílem tohoto projektu je vytvořit vizuální efekt „dýchání“ implementovaný na vývojové desce Nexys A7-50T. Projekt využívá pulzně šířkovou modulaci (PWM) k plynulé změně jasu LED diod.

### Hlavní funkce projektu:

* **Plynulé dýchání diod:** Jas LED diody se mění podle PWM signálu který napodobňuje trojuhelníkový signál, což simuluje přirozený cyklus nádechu a výdechu. Čas nádychu je nastavitelnej.
- **Priestorový nádych/výdych:** Využíva radu 16 diod, ktoré sa postupne zapnú a vypnú tvoriac nádych a výdych. Niečo podobné "progress baru". Čas nádychu je nastaviteľný.
* **Nastavitelná rychlost:** Pomocí dvou přepínačů (switches) lze měnit čas nádychu od 1s až po 8s.
* **Vizuální zpětná vazba:** Aktuálně zvolený čas nádychu je v reálném čase zobrazován na sedmisegmentovém displeji.
- **Ďaľšie módy (:TODO)**

---

### Ovládání a parametry:

Uživatelské rozhraní je navrženo pro maximální jednoduchost s využitím prvků přímo na desce:

| Prvek | Funkce | Popis |
| :--- | :--- | :--- |
| **Switches [M13, L16, J15]** | Nastavení rychlosti | 3-bitové číslo (0-7 + 1) určující rychlost cyklu. |
| **Switches [V10, V11, V12]** | Nastavení módu | 3-bitové číslo určující mód zobrazení dýchaní. |
| **LED [15:0]** | Výstupní signál | Podle zadaného módu zobrazuje různé efekty dýchání. |
| **7-seg displej** | Indikátor | Zobrazuje aktuální čas nádechu (1s, 2s, 3s atd.). |

---

### Funkcie jednotlivých entít, detaily:

- **Entitat constant_pwm:** Generuje konštantný PWM signál so zadanou veľkosťou (0 - 255bit číslo reprezentujúce 0 - 100%)
- **Entita breathing_pwm:** Generuje premenlivý PWM signál so zadaným časom nádychu, simulujúc nádych/výdych.
- **Entita seg_decoder:** Dekóduje 3 bitové binárne číslo (čas nádychu), ktoré zobrazí na 7 segmentovom displaji. 
* **Logika času:** Prepínače definujú čas (1-7s) nádychu/výdychu.
* **Implementace:** Vytvořeno v jazyce VHDL pro FPGA Artix-7 (Nexys A7-50T/100T).

---

### Jak projekt zprovoznit:
1. Použite predpripravený projek pre IDE **Xilinx Vivado** z Github repozitára.
3. Proveďte syntézu, implementaci a generování bitstreamu.
4. Nahrajte program do desky a pomocí prvních dvou switchů ovládejte rychlost.

Linux:
1. Naklonovať github repozitár do nejakého priečinku.
2. Nainštalovať si ghdl a GTKWave, mať ich v globálnej ceste.
3. Premiestniť sa (ak nainštalované do downloads, potom ``cd ~/Downloads/pwm-breathing-led/sim``) do sim priečinku.
5. Upraviť V Makefile premennú TOP na meno testbenchu (napr. tb_breath_leds), ktorý chceme simulovať a vidieť jeho waveformu.
4. V konzoli buildnúť projekt cez ``make`` a cez ``make view`` vidieť waveformy.


## Blokový diagram
![Blokový diagram dýchacích LED](/img/block_diagram.jpg)

:TODO Treba aktualizovať aby odpovedal architektúre

## Simulácie
Simulácia konštantného PWM signálu
![constant_pwm_view](/img/signal_views_imgs/constant_pwm_view.png)

Simulácia módu "Dýchajúca LED" (premenný PWM signál)
![breathing_pwm_view](/img/signal_views_imgs/breathing_pwm_view.png)

Simulácia módu "Progress bar"
![progress_bar_view](/img/signal_views_imgs/progress_bar_view.png)

Simulácia módu "Pyramída"
![pyramid_view](/img/signal_views_imgs/pyramid_view.png)

Simulácia módu "Hviezdy"
![stars_view](/img/signal_views_imgs/stars_view.png)

Simulácia top level entity breathing_led_top
![top_level_view](/img/signal_views_imgs/top_level_view.png)

## Poster, atď
:TODO