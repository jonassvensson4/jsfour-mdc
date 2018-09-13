# jsfour-mdc

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

* Kör SQL-filen, får du error så får du importera de manuellt. Vissa (dåliga) SQL-program klarar inte av primary keys
* Lägg till lastdigits i tabellerna users och characters, <a href="https://github.com/jonassvensson4/jsfour-register">jsfour-register<a/> har en SQL-fil du kan köra
  - Du måste ha ett script, alternativt lägga in lastdigits själv på alla användare då scriptet kräver detta. Du kan även använda mitt jsfour-register
* Använder du inte mitt <a href="https://github.com/jonassvensson4/jsfour-brottsregister">jsfour-brottsregister<a/> så kommer du förmodligen få en error, rekommenderar dig att använda det. Alternativt ändra om i server.lua
* Har du lagt till egna polisbilar så måste du lägga till modellnamnet i config.lua
* Lägg till alla poliser i html/assets/js/passwords.js. Det står vad som behvövs där. Vid nyrekrytering så måste scriptet alltså startas om. Alternativt så får den personen använda något annat lösenord tillsvidare
* Har du den senaste versionen av esx_vehicleshop så måste du ersätta orginalfilerna med de som ligger i mappen optional
  
### GUIDE
* För att öppna datorn så måste polisbilen så still, du klickar sedan på Y
* För att ta bort en anmärkning på bilen eller något ur brottsregistret så klickar du på den raden du vill ta bort. Här nedan så står det Test (2018-08-10) i brottsregistret och Fortkörning (2018-07-30). Det är alltså dessa du kan klicka på så tas de bort från databasen
* Det finns en tab i menyn som inte alla ser. "Loggboken" ser endast de som har adminrättigheter i html/assets/js/passwords.js. Där loggas allt som tas bort. Där står det vem som tagit bort det och vad som togs bort
* Minutstecknet under PERSONINFO vid efterlyst tar bort efterlysningen om personen är efterlyst. Den försvinner även om du tar bort efterlysningen från efterlys-taben
* Vill du efterlysa någon men du saknar uppgifter om en person t.ex personnumret så kan du skriva dit Unknown, okänd eller okänt istället
* Det finns en rad som heter besiktigad under FORDONSINFO. För tillfället går den raden inte att ändra. Den kommer alltid stå som JA på alla bilar. Det är planerat att det ska komma ett script för detta då det här är inget som polisen ska kunna ändra
* Vill du lägga till lagar i REGELVERKET så gör du det i html/assets/js/regelverk.js

### Screenshot
![screenshot](https://i.gyazo.com/f1686551d68855578946b48b3dce6be7.png)
![screenshot](https://i.gyazo.com/dbd27b12f6df5ad8784ddd63eb23afdc.png)
![screenshot](https://i.gyazo.com/3859cdd56e2be8a5a18c8ea4f4c0a2d7.png)
![screenshot](https://i.gyazo.com/45614bc6e29e50e2ee136f7e68d7ec27.png)
![screenshot](https://i.gyazo.com/b60e73635bd1aa7c2af55527d3e0c724.png)
![screenshot](https://i.gyazo.com/98fb97ef1ce1d706b710862f899cad3e.png)
