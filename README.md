# jsfour-mdc

Mobile Data Computer, a computer that can be access from every police car:

(NOTE! Check the screenshots at the bottom to understand it better)

* Search for a person by using the date of birth
  - You can see if the person is wanted or not and some basic information about the person. It also fetches information from my criminal record which is also displayed at the page.
* Search cars by the plate
  - You can see who owns the car, if the car has any notes and if the car has been inspected (It will always say YES for now)
  - Notes = If someone is speeding you can add a note to the car. If the car gets pulled over a second time the officer will see that note. It's a way to keep track of all the violations. 
* Add a incident
  - If someone commits a crime you can add it as an incident which every officer will see. Or if someone want to report a crime you could also make an incident.
* Wanted-tab
  - Make a person wanted and see who's wanted
* DNA
  - If you're using my jsfour-dna you can now upload it from the car. If you're not using my dna-script you can ignore this feature.
* Regulations
  - Mostly there to fill out the space. You can add rules/laws and whaterver you want the officers to see

### LICENSE
Please don't sell or reupload this resource

### INSTALLATION
* You need to have ESX installed
* The folder needs to have the name **jsfour-mdc** nothing else will work
* Run the SQL-file

* Add lastdigits in the table users and characters, <a href="https://github.com/jonassvensson4/jsfour-register">jsfour-register<a/> has an SQL-file you can run.
  - You need to have a script, or add the lastdigits manually to every player. Or you could use my jsfour-register
* If you doesn't use my <a href="https://github.com/jonassvensson4/jsfour-criminalrecord">jsfour-criminalrecord<a/> you'll probably get an error so I recommend you to use it. Or make some changes in the server.lua
* If you've added custom car-models for the police cars you might have to add them to the config.lua
* Add all the officers lastdigits with a password to html/assets/js/passwords.js. There's more information in that file. If someone becomes a officer while the server is running the script will need a restart OR they could just use someone elses password meanwhile.
* Make sure you're using the latest version of esx_vehicleshop
  
### GUIDE
* To be able to open the computer the car can't be moving. Press Y to open it
* If you want to remove a Note from a vehicle you simply press the note you want to remove. So in the screenshot there's a note called "Fortkörning (2018-07-30)". Same goes for the criminal record under the PERSONAL INFORMATIO tab. You simply click the "Test (2018-08-10)" and it will be removed from the database.
* There's a tab at the bottom called LOGS. Only the officers within the admin-section in html/assets/js/passwords.js is able to see that tab. You can see everything that has been removed in this tab
* The minus-circle icon under the PERSONAL INFORMATION tab will remove the wanted from that person. It will also be removed if you remove the wanted from the wanted-tab 
* If you want to make someone wanted but you don't know their DOB you can use enter Unknown as DOB.
* There's a row under the CAR INFO tab where it says "inspected". This can't be changed at the moment so it will say YES on every car.
* If you want to change stuff in the regulations you'll find that file here: html/assets/js/regelverk.js

### Screenshots
![screenshot](https://i.gyazo.com/f1686551d68855578946b48b3dce6be7.png)
![screenshot](https://i.gyazo.com/dbd27b12f6df5ad8784ddd63eb23afdc.png)
![screenshot](https://i.gyazo.com/3859cdd56e2be8a5a18c8ea4f4c0a2d7.png)
![screenshot](https://i.gyazo.com/45614bc6e29e50e2ee136f7e68d7ec27.png)
![screenshot](https://i.gyazo.com/b60e73635bd1aa7c2af55527d3e0c724.png)
![screenshot](https://i.gyazo.com/98fb97ef1ce1d706b710862f899cad3e.png)
