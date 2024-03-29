import 'package:djiguiba_music/consts/colors.dart';
import 'package:djiguiba_music/controllers/player_controller.dart';
import 'package:djiguiba_music/sous_pages/musis_page_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts/text_style.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    //set controller to getX
    var playerController = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: whiteColor,
              ))
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        title: Text(
          'Dji_Music',
          style: monTextStyle(
            family: bold,
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: playerController.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'Pas de music',
              style: monTextStyle(),
            ));
          } else {
            print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Obx(
                          () => ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            tileColor: bgColor,
                            title: Text(
                              snapshot.data![index].displayNameWOExt,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: monTextStyle(
                                family: bold,
                                size: 15,
                              ),
                            ),
                            subtitle: 
                            Text(
                              '${snapshot.data![index].artist}',
                              style: monTextStyle(
                                family: regular,
                                size: 12,
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                color: whiteColor,
                                size: 32,
                              ),
                            ),
                            trailing:
                                playerController.playIndex.value == index &&
                                        playerController.isPlaying.value
                                    ? const Icon(
                                        Icons.pause,
                                        color: whiteColor,
                                        size: 26,
                                      )
                                    : null,
                            onTap: () {
                              if (kDebugMode) {
                                print(
                                    'index from player ${snapshot.data![playerController.playIndex.value].id}');
                              }
                              Get.to(() =>
                                  MusicPageDetail(songList: snapshot.data!));
                              if (playerController.isPlaying.isFalse ||
                                  playerController.playIndex.value != index) {
                                playerController.playSong(
                                    snapshot.data![index].uri, index);
                              }
                            },
                          ),
                        ));
                  }),
            );
          }
        },
      ),
    );
  }
}
