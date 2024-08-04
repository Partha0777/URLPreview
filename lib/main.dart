import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, Future<PreviewData>> _dataCache = {};

  List<String> get urls => const [
    'https://www.flipkart.com/poco-m6-pro-5g-power-black-128-gb/p/itmef8fa46f89738?pid=MOBGRNZ3ER4N3K4F&lid=LSTMOBGRNZ3ER4N3K4FIYYGCU&marketplace=FLIPKART&store=tyy%2F4io&spotlightTagId=BestsellerId_tyy%2F4io&srno=b_1_1&otracker=browse&fm=organic&iid=223f3aac-9f1f-427e-8fd3-061ced12e537.MOBGRNZ3ER4N3K4F.SEARCH&ppt=browse&ppn=browse&ssid=1adck2t5e80000001722693892812',
    'https://www.amazon.in/LEGO-Champions-Mercedes-AMG-Performance-Project/dp/B0B8NXFFSH/?_encoding=UTF8&pd_rd_w=SWduZ&content-id=amzn1.sym.f8b2fc0c-779f-43a6-b25a-069849dd23a6%3Aamzn1.symc.fc11ad14-99c1-406b-aa77-051d0ba1aade&pf_rd_p=f8b2fc0c-779f-43a6-b25a-069849dd23a6&pf_rd_r=GSCQDJHNR2BGJR107BZQ&pd_rd_wg=ijyKu&pd_rd_r=81daf687-6ae7-4ce5-bf12-6c196009a2fa&ref_=pd_hp_d_atf_ci_mcx_mr_ca_hp_atf_d',
   'https://www.amazon.in/Samsung-Galaxy-Smartphone-Silver-Storage/dp/B0D83YD1TF/ref=sr_1_1_sspa?crid=LP76ZCZ9GJSB&dib=eyJ2IjoiMSJ9.qQ9Cfk186E8fFQPvICSvDjlVrr8bcIca49Z1zwow3xD3ia81j0m53tDwBY94PDOZgBnzbNiJMr8Z0QlwBt3FNOI3PtEoHGT33RnEgQvwbseK6LzAoKnpAJ85rNxNBFyE_PiwI5t2ATBGSvIVBxdxuWMFMnGA5J6lcoS2zNtHpd7bZLJjEAqBfD3PWr9USvkeMOFWiqUNStJXd0aA7VzqtqLhpxjmUEhmE41SE9ODqfo.-Leh3HVlUEOL6VVKKbByabLLV3EAoggQacD3ymz7DX4&dib_tag=se&keywords=samsung%2B5g%2Bmobile&qid=1722710919&sprefix=sa%2Caps%2C287&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1',
    'https://www.myntra.com/jeans/rareism/rareism-women-pink-slim-fit-slash-knee-jeans/20744022/buy',
    'https://www.flipkart.com/apple-iphone-15-pro-max-blue-titanium-1-tb/p/itmc556a7f74123f?pid=MOBGTAGQRFZHFGXC&lid=LSTMOBGTAGQRFZHFGXCOAO2IL&marketplace=FLIPKART&q=apple+iphone+15+pro+max&store=tyy%2F4io&srno=s_1_7&otracker=AS_QueryStore_OrganicAutoSuggest_1_16_na_na_ps&otracker1=AS_QueryStore_OrganicAutoSuggest_1_16_na_na_ps&fm=search-autosuggest&iid=58047896-3065-49bc-b4f5-1d7e221398b4.MOBGTAGQRFZHFGXC.SEARCH&ppt=sp&ppn=sp&ssid=1us6rtdzwg0000001722699920394&qH=d2ebe7275758267b',
    'https://www.amazon.in/D2C-Programmer-Developer-Professional-Size-58mm/dp/B0BWS6R5LM/ref=pd_ci_mcx_mh_mcx_views_0?pd_rd_w=iQ06C&content-id=amzn1.sym.120dbce3-1ee8-4441-9b7e-775b1c676a73%3Aamzn1.symc.ca948091-a64d-450e-86d7-c161ca33337b&pf_rd_p=120dbce3-1ee8-4441-9b7e-775b1c676a73&pf_rd_r=JSV70EMGFQKNN2A86GYK&pd_rd_wg=WpFgq&pd_rd_r=6321408c-b321-4e45-a3c7-eebb62f16a88&pd_rd_i=B0BWS6R5LM',
    'https://www.amazon.in/dp/B08V5G3J5Z/ref=syn_sd_onsite_desktop_0?ie=UTF8&pf_rd_p=fd82b077-06f6-479f-8fb9-11c7d326b43b&pf_rd_r=KGZDEG02MJCHEPR38NE7&pd_rd_wg=Gqut9&pd_rd_w=foZHM&pd_rd_r=efcec4ec-5b16-4b85-8f8f-647932b708ce&aref=OLCsOh1Pr4&th=1'
  ];

  @override
  void initState() {
    super.initState();
    // Preload data if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: urls.length,
                itemBuilder: (context, index) {
                  String url = urls[index];
                  return FutureBuilder<PreviewData>(
                    future: _dataCache[url] ??= previewData(url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                color: Colors.white,
                                height: 150,
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return
                          Card(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(4),
                                color: Colors.white,
                                  child: Image.network(snapshot.data?.image?.url ?? "", height: 140, width: 120),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8,right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot.data?.title ?? "",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 12),
                                      Text(
                                          snapshot.data?.description ?? "",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 12)),
                                      GestureDetector(
                                        onTap: (){
                                          launchUrl(Uri.parse(urls[index]));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.blue,
                                              borderRadius:
                                              BorderRadius.circular(24)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                  Uri.parse(urls[index]).host,
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(width:8),
                                              Icon(Icons.arrow_circle_right,size: 20,color: Colors.white,)
                                            ],
                                          ),
                                        )
                                        ,
                                      )
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text("No data available");
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PreviewData> previewData(String url) async {
    print("Fetching data for $url");
    // Your data fetching logic here
    return await getPreviewData(
      url,
      proxy: null,
      requestTimeout: null,
      userAgent: null,
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}


/*
  Future<void> _fetchData(List<String> urlList) async {
    for (String i in urlList) {
      final previewData = await getPreviewData(
        i,
        proxy: null,
        requestTimeout: null,
        userAgent: null,
      );
      dataList.add(previewData);
    }
    setState(() {
      loadingCompleted = true;
    });
  }
*/


