import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:val_flutter/agent_detail_page.dart';
import 'package:val_flutter/api.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final api = RestApi();

  final listAgents = <dynamic>[];

  @override
  void initState() {
    fetchAgent();
    super.initState();
  }

  Future<void> fetchAgent() async {
    listAgents.clear();
    final response = await api.fetchAgent();

    if (response.isNotEmpty) {
      for (final agent in response['data']) {
        if (agent['isPlayableCharacter']) {
          listAgents.add(agent);
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agents Valorant'),
        elevation: 4,
      ),
      body: listAgents.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2 / 3,
              ),
              itemCount: listAgents.length,
              itemBuilder: (context, index) {
                final agent = listAgents[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AgentDetailPage(agent: agent),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: getGradientsColor(
                              agent['backgroundGradientColors']),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: agent['background'],
                              ),
                              CachedNetworkImage(
                                imageUrl: agent['fullPortrait'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Color> getGradientsColor(List listGradient) {
    final listColor = <Color>[];

    for (var color in listGradient) {
      final newColor = int.parse('0XFF$color');

      listColor.add(Color(newColor));
    }
    return listColor;
  }
}
