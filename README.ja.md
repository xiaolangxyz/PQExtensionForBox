## カスタムコネクタを使用してPower BIのボックスファイルにアクセスする
*Read this in other languages: [English](README.md), [日本語](README.ja.md).*

The way to use this project.

1. Step1: ボックスのアプリを作成する. [開発者コンソールに移動](https://developer.box.com/)

       1. 「企業統合」を選択する。
	   
	   2. [標準OAuth 2.0(ユーザー認証)]を選択する。
	   
	   3. アプリの名前を入力し、アプリを作成する。
	   
	   4. OAuth 2.0資格情報のクライアントIDとクライアント機密コードをメモする。
	   
2. Step2: mezファイルをビルドする。

       1. 本リポジトリをクローンする。
	   
	   2. PQExtensionForBox.mprojをビジュアルスタジオで開く。
	   
	   3. ステップ1.4でメモした、クライアントIDとクライアント機密コードをclient_idとclient_secretにセットする。
	   
	   4. プロジェクトをビルドする。
	   
3. Step3: mezファイルをPower BIの環境にコピーする。

       1. PQExtensionForBox\bin\Debug\PQExtensionForBox.mezをDocuments\Power BI Desktop\Custom Connectorsにコピーする。
