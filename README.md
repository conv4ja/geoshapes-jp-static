# ABOUT

<a rel="license" href="https://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

このプロジェクトは国立情報学研究所 [Geoshapeリポジトリ](https://geoshape.ex.nii.ac.jp/city/)の提供する市町村境界データのコンテンツを、より便利に利用するためのリポジトリです。
[Geoshapeプロジェクト](https://geoshape.ex.nii.ac.jp/city/) では平成27年時点での市町村境界データがGeoJSONないしはTopoJSON形式にて提供されており、本リポジトリでは現在の市町村境界の標準地域コードに対応するミラーコンテンツを `src/geojson` および `src/topojson` 配下に格納しています。

[ファイル配信サイト](#Distribution)では、各境界データを静的コンテンツとしてホストします。
ファイル単位での取得をご希望の場合はこちらもご利用ください。

なお、本リポジトリ `/src` 配下のgeojsonおよびtopojsonコンテンツは NII/CODH によりCC BY-SA 4.0 にて利用許諾されており、再利用の際は次のクレジット表記が必要となります。

`『歴史的行政区域データセットβ版』（CODH作成）`

もしくは

` Asanobu KITAMOTO, ROIS-DS Center for Open Data in the Humanities, CC BY-SA 4.0 `

なお、各コンテンツについては国土交通省の「[国土数値情報](http://nlftp.mlit.go.jp/ksj/)」をもとに作成されています。
原データの利用規約については[こちら](http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-N03.html)をご確認ください。


各種シンボリックリンク構成および `/src` 以外の各種コンテンツは [@g1eng](https://github.com/g1eng) の手によるものです。
本リポジトリを再利用する場合には、CC BY-SA 4.0 クレジット表記に `Nomura Suzume` を追記してください。

# Distribution

各シェープファイルを静的コンテンツとして配信するサービスを提供します。
いずれもGETリクエストのみ受け入れる擬似的なAPIエンドポイントとして振る舞います。

* [GitHub](https://g1eng.github.io/geoshapes/)


## APIリソースについて

* すべてのリソースについて、GETリクエストのみ受け付けます。
* github.ioではMIMEヘッダはサポートしません。リソースのMIMEタイプが正常に解釈されない場合があります。

| endpoint | name | response example | 
| --- | --- | --- |
| /health | API稼働状況を取得します | status only |
| /version | APIバージョンを取得します | {"version": "0.1.1", "language":"ja"} |
| /prefecture/listAll | 都道府県一覧を取得します | { "北海道": "01", ... } |
| /city/listAll | 市町村一覧を取得します | { "小樽市":"01101", ..., "八重山町":"47483" } |
| /city/list/:prefCode | 都道府県内の市町村一覧を取得します | { "小樽市":"01101", ... } |
| /city/info/:cityCode | 標準地域コードから市町村メタデータを取得します | {"川越市" |
| /city/info/:prefName/:cityName | 市町村名から市町村メタデータを取得します | 14101 |
| /city/info/:prefCode/:cityName | 市町村名から市町村メタデータを取得します | 14101 |
| /:fmt/:cityCode | 市町村コードで境界データを取得します |  |

fmt: 境界データフォーマット geojson|topojson|pbf
prefCode: 2桁の都道府県コード (e.g. 11)
cityCode: 5桁表記の標準地域コード (e.g. 12101)

# 謝辞

行政区域データ・セットを提供いただきました、NII北本研究室に感謝いたします。


# 作業者

Nomura Suzume <suzume315[at]g00.g1e.org>
