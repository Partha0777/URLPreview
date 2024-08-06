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
        'https://www.flipkart.com/mobile-phones-store?fm=neo%2Fmerchandising&iid=M_a76a398a-8bb3-44e2-81f5-5bcda3bcfd0b_1_372UD5BXDFYS_MC.ZRQ4DKH28K8J&otracker=hp_rich_navigation_2_1.navigationCard.RICH_NAVIGATION_Mobiles_ZRQ4DKH28K8J&otracker1=hp_rich_navigation_PINNED_neo%2Fmerchandising_NA_NAV_EXPANDABLE_navigationCard_cc_2_L0_view-all&cid=ZRQ4DKH28K8J',
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.white,
                                height: 150,
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            showProductInBottomSheet(
                                snapshot.data, urls[index]);
                          },
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            color: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.white,
                                  child: Image.network(
                                      snapshot.data?.image?.url ??
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk9ox9PplrrJl-lGvf1KH5OjKzS6xfKTnVmQ&s",
                                      height: 140,
                                      width: 120),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data?.title ?? "",
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 12),
                                          Text(snapshot.data?.description ?? "",
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          GestureDetector(
                                            onTap: () {
                                              launchUrl(Uri.parse(urls[index]));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                      Uri.parse(urls[index])
                                                          .host,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Icon(
                                                    Icons.arrow_circle_right,
                                                    size: 20,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text("No data available");
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

  void showProductInBottomSheet(PreviewData? previewData, String url) {
    showModalBottomSheet(
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.white,
              child: Image.network(
                  previewData?.image?.url ??
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk9ox9PplrrJl-lGvf1KH5OjKzS6xfKTnVmQ&s",
                  height: 200),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(previewData?.title ?? "",
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(previewData?.description ?? "",
                        overflow: TextOverflow.clip,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(url));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24)),
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Visit ${getNameFromUrl(url).capitalize()}",
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_circle_right,
                                    size: 24,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        );
      },
    );
  }

  String getNameFromUrl(String url) {
    // Parse the URL
    Uri uri = Uri.parse(url);

    // Get the host part of the URL
    String host = uri.host;

    // Remove 'www.' if present
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }

    // Split by '.' and take the first part to get the name
    List<String> parts = host.split('.');
    if (parts.isNotEmpty) {
      return parts.first;
    }

    // Return the host if the name extraction fails
    return host;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
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
