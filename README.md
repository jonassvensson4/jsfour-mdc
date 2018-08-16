# jsfour-mdc
UNDER UTVECKLING! OBSERVERA ATT DESIGN KAN KOMMA ATT ÄNDRAS, MEN GRUNDPRINCIPERNA KVARSTÅR

Mobile Data Computer, en polisdator som finns i alla polisbilar där du kan göra följande:

(OBS! Kolla på bilderna längst ner för att lättare förstå)

* Söka efter personer via personnummer
  - Här kan du se om en person är efterlyst och dess brottsregistret, även lite grundläggande information. Den hämtar brotts-inforamtion från mitt brottsregister-script
* Söka upp bilar via reggnummer
  - Här ser du vem som äger bilen, om bilen har fått några anmärkningar vid tidigare kontroll samt om den är besiktigad
* Skriva incidenter
  - Här kan du skriva ned olika händelser som sker vid ett brott för att senare skapa en efterlysning så kollegorna vet varför personen är efterlyst
* Efterlysningar
  - Här kan du se alla personer som är efterlysta samt lägga in efterlysningar
* DNA
  - För er som använder mitt DNA-script så kan man nu ladda upp DNA via den här datorn. För er som inte använder det så bortse från den funktionen.
* Regelverk
  - Mest en utfyllnadsgrej men kan vara trevligt att ha om poliserna måste kolla upp någon lag

### LICENSE
Du får mer än gärna ändra vad du vill i scriptet men du får INTE sälja vidare scriptet eller ladda upp det på nytt, hänvisa folket hit istället.

### INSTALLATION
För att scriptet ska fungera så behöver du använda dig av ESX.

* Kör SQL-filen
* Lägg till lastdigits i tabellerna users och charachters, <a href="https://github.com/jonassvensson4/jsfour-register">jsfour-register<a/> har en SQL-fil du kan köra
  - Du måste ha ett script, alternativt lägga in lastdigits själv på alla användare då scriptet kräver detta. Du kan även använda mitt jsfour-register
* Använder du inte mitt jsfour-brottsregister så kommer du förmodligen få en error, rekommenderar dig att använda det. Alternativt ändra om i server.lua

### Screenshot
![screenshot](https://i.gyazo.com/f1686551d68855578946b48b3dce6be7.png)
![screenshot](https://i.gyazo.com/dbd27b12f6df5ad8784ddd63eb23afdc.png)
![screenshot](https://i.gyazo.com/3859cdd56e2be8a5a18c8ea4f4c0a2d7.png)
![screenshot](https://i.gyazo.com/45614bc6e29e50e2ee136f7e68d7ec27.png)
![screenshot](https://i.gyazo.com/b60e73635bd1aa7c2af55527d3e0c724.png)
![screenshot](https://i.gyazo.com/98fb97ef1ce1d706b710862f899cad3e.png)
