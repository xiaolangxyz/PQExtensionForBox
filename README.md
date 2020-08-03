# PQExtensionForBox
Use custom connector to access box files in PowerBI

The way to use this project.

1. Step1: Create a box app. [Go to Dev Console](https://developer.box.com/)
       1. Choose Enterprise integration
	   2. Choose Standard OAuth 2.0(User Authentication)
	   3. Name your app and create it
	   4. Memorize your client ID and Client secret which is in Configuration page
	   
2. Step2: Build your own mez file
       1. Clone this project
	   2. Open PQExtensionForBox.mproj using visual studio.
	   3. Set your Box's client_id and client_secret which are memorized at step 1.4
	   4. build the project
	   
3. Step3: Cope mez file to your Power BI environment
       1. Copy PQExtensionForBox\bin\Debug\PQExtensionForBox.mez to Documents\Power BI Desktop\Custom Connectors
