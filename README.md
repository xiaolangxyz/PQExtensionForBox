## Use custom connector to access box files in PowerBI
*Read this in other languages: [English](README.md), [日本語](README.ja.md).*

The way to use this project.

requirements: Visual Studio 2015, 2017, 2019, [Power Query SDK](https://marketplace.visualstudio.com/items?itemName=Dakahn.PowerQuerySDK)

1. Step1: Create a box app. [Go to Dev Console](https://developer.box.com/)

       1. Choose Enterprise integration.
	   
	   2. Choose Standard OAuth 2.0(User Authentication).
	   
	   3. Name your app and create it.

	   1. set (https://oauth.powerbi.com/views/oauthredirect.html) to OAuth 2.0 redirect URI and CORS domain.
	   
	   4. Memorize your client ID and Client secret which is in Configuration page.
	   
2. Step2: Build your own mez file.

       1. Clone this project.
	   
	   2. Open PQExtensionForBox.mproj using visual studio.
	   
	   3. Set your Box's client_id and client_secret which are memorized at step 1.4.
	   
	   4. build the project.
	   
3. Step3: Cope mez file to your Power BI environment.

       1. Copy PQExtensionForBox\bin\Debug\PQExtensionForBox.mez to Documents\Power BI Desktop\Custom Connectors.

4. Step4: Access box files throught  Power BI Desktop.

	   1. Set custom connectors. Follow the steps [here](https://docs.microsoft.com/ja-jp/power-bi/connect-data/desktop-connector-extensibility#custom-connectors).

       1. Open Power BI Desktop.

	   2. Click [Get Data]。

	   3. Search [PQExtensionForBox.Simple] and connect it.

	   4. Input the folder uri which ypou want to access

	   5. Sign in using your box account

	   6. File List would be showed as a table in navigator window. csv and excel file contents are stored in content column.
