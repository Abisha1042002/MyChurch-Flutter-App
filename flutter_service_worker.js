'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5f178be5ec73c6621b9c5444b8df0ae1",
"assets/AssetManifest.bin.json": "34bfda8c7d98ecef36f1967738516806",
"assets/AssetManifest.json": "60ac9df54b5c0efca7675c70e0b15bb3",
"assets/assets/Aananthame/01.Prayer.mp3": "713899fe387de148c36abd0bec6d8132",
"assets/assets/Aananthame/02.Aananthame.mp3": "be70b73a91aad5e0a98d1a472e151eea",
"assets/assets/Aananthame/03.Sarvalokathipa.mp3": "8a062e589a65437dc03985ac5e5e456b",
"assets/assets/Aananthame/04.Engum%2520Pugazh.mp3": "2010b85e7684dbdc5ab2648786d80ff1",
"assets/assets/Aananthame/05.Nambi%2520Vanthene.mp3": "a5eb6e52da40343aafa372b49e9cb388",
"assets/assets/Aananthame/06.Devane.mp3": "0f893965f881b68737193ad9ae90a235",
"assets/assets/Aananthame/07.Amala.mp3": "344aabac88e33eecf522597b53d52684",
"assets/assets/Aananthame/08.Theeya%2520Manathai.mp3": "2a1c3e9404db44c69708dfff312da084",
"assets/assets/Aananthame/09.Dhasare.mp3": "5a6f621bb544b79ffc6e8ec7f11a5f7a",
"assets/assets/Aananthame/10.Sundara%2520Parama.mp3": "396b8040b820ddf5595eeea8826c711c",
"assets/assets/Aananthame/11.Nadakka%2520Cholli.mp3": "0b1d5e8dac9f17736b46b9e680210450",
"assets/assets/Aananthame/12.Yesu%2520Kristhu.mp3": "f1f47f0e7cf7f5901f9aec62a80d6241",
"assets/assets/Aananthame/13.Iraivan.mp3": "a1dfd3fa0806458f1909f07ed88d6973",
"assets/assets/Aananthame/14.Ennai%2520Nesi.mp3": "68db3e26203f5157f30b3a4899aebf64",
"assets/assets/Aananthame/15.Unthan%2520Sitham.mp3": "f41a97781baafb50924920a72191d66e",
"assets/assets/Aananthame/16.Ser%2520Ayya%2520Ezhiyen.mp3": "362ba09bb2a7a8193b79a546086950eb",
"assets/assets/Aananthame/17.Iraiva%2520Enakku.mp3": "ca400b111c02a3f4960778dfb7839890",
"assets/assets/Aananthame/18.Karthane%2520En.mp3": "1cfc30e3f815ee875719f3e224308d30",
"assets/assets/Aananthame/19.Azhagai%2520Nirkkum.mp3": "e3b9fd69a36936b398b10eee5889b8fc",
"assets/assets/Aananthame/20.Intha%2520Naalai%2520Naan.mp3": "49058d45d8e324ac0d421ee6b2025853",
"assets/assets/Aananthame/21.Vaasalandai.mp3": "6256ff87f28e8e525fb746a8365ba8c4",
"assets/assets/Aananthame/22.Alleluyah.mp3": "af8755a4bf0cfbbaabf27fa9c8bb9291",
"assets/assets/Aananthame/23.Iraivan%2520Namakku.mp3": "d9bccba6933939ea23dd651162d1c21d",
"assets/assets/Aananthame/24.Devan%2520Varugirar.mp3": "76bc78c0103ffbd05ed5b6f7d82bab6f",
"assets/assets/Aananthame/25.Chinnam%2520Chiriya.mp3": "2ebdafce8dd88e247d866bace33d20f5",
"assets/assets/Aananthame/26.Vinnaga%2520Thanthai.mp3": "33b6767a9a5b604b4baddd3d2d5dc67e",
"assets/assets/Aananthame/27.En%2520Yesuve.mp3": "39a22a383c7afd0feecdba10491c08c4",
"assets/assets/Aananthame/28.Jeeviyame.mp3": "4ebc3fc767597330cb1e282ea4b7b16b",
"assets/assets/Aananthame/29.Kartharinkai.mp3": "5e76cca2d85d8985251d151ad1d08a5a",
"assets/assets/Aananthame/30.Aazhntha%2520Setrinile.mp3": "fb17b1ed17dfba78dcbb46a52284ca6a",
"assets/assets/Aananthame/31.Anathi%2520Devan.mp3": "bd8fba6b62571bf66c8542cc2defb704",
"assets/assets/Aananthame/32.Aadhavan%2520Uthikkum.mp3": "880f37844d60ec6f57a088c3b8b53f93",
"assets/assets/Aananthame/33.Thiruppatham%2520Nambi.mp3": "ad3e28f9cae6fb76265610698aa29f72",
"assets/assets/Aananthame/34.Kattadam%2520Kattidum.mp3": "efed6936326bd611c667a4b72f729629",
"assets/assets/Aananthame/35.Andin%2520Devan.mp3": "24cd58ffc9b52c790319b75304562b37",
"assets/assets/Aananthame/36.Yezhaikku%2520Pangalanam.mp3": "b077054607bdccdd246605bec88480a9",
"assets/assets/Aananthame/37.Ulagam%2520Tharatha.mp3": "dd0a61d667ee585ae68d7e9e37683b52",
"assets/assets/Aananthame/38.Varuvai%2520Tharunam.mp3": "2bb7e3487e95256ac80fb5fbe7262ebe",
"assets/assets/Aananthame/39.Kelungal%2520Tharappadum.mp3": "530e15bfb69dc5ba0bf08e0619eac1f4",
"assets/assets/Aananthame/40.Yaaridam%2520Solvom.mp3": "7c8155a6b5e3ac3f28ec7e80fca888bb",
"assets/assets/ad1.png": "3f82eb1c522f9a420a316a61aafe88c3",
"assets/assets/ad2.png": "60de325c73cfdcbcfaaf0e2aacda26f0",
"assets/assets/ad3.png": "dc10bc7e69b4a60b0098c790caf85539",
"assets/assets/ad4.png": "531b86b9771128a270a9f1512e771640",
"assets/assets/AKJV.json": "6df990b1fce82e6b211b0cd4f8dd7596",
"assets/assets/audio_files.json": "5c441120c2c4267100bfe010b945107a",
"assets/assets/Bible-tamil-main/1%2520Chronicles.json": "b87f99bcf8957d1cf2984de82b98beb8",
"assets/assets/Bible-tamil-main/1%2520Corinthians.json": "e88703b58b7fe22af99b49d2d3eb31d0",
"assets/assets/Bible-tamil-main/1%2520John.json": "7d49a710fa84519ee9f82592ee1a1bcc",
"assets/assets/Bible-tamil-main/1%2520Kings.json": "b5cb78ae4e6a91e5e0812a35c3782e54",
"assets/assets/Bible-tamil-main/1%2520Peter.json": "8441ec96de539a24fef1882e038c8966",
"assets/assets/Bible-tamil-main/1%2520Samuel.json": "0f36934f6c38c6d5c20f473271fd1e97",
"assets/assets/Bible-tamil-main/1%2520Thessalonians.json": "658625cb2461dec5b9acb759294eb8da",
"assets/assets/Bible-tamil-main/1%2520Timothy.json": "79cdefdfeef4a9c4f7a92b679359f4e1",
"assets/assets/Bible-tamil-main/2%2520Chronicles.json": "e8b3f73d00f3d45718ce4b27bad2e754",
"assets/assets/Bible-tamil-main/2%2520Corinthians.json": "8d5d2a900f4d0da48924104d90816398",
"assets/assets/Bible-tamil-main/2%2520John.json": "cc4c4d4bd178c40b4a8c23853d83e47c",
"assets/assets/Bible-tamil-main/2%2520Kings.json": "5262d20f90c4c493078debad69097fa6",
"assets/assets/Bible-tamil-main/2%2520Peter.json": "9f14407c88d2af724edc663e1d727c62",
"assets/assets/Bible-tamil-main/2%2520Samuel.json": "e485900cae122324b3e19f0eee0bc285",
"assets/assets/Bible-tamil-main/2%2520Thessalonians.json": "b8925ae5a7493cc34ea0c069e63da7ef",
"assets/assets/Bible-tamil-main/2%2520Timothy.json": "df21fe1ede0c61ed51090e90913bdd1d",
"assets/assets/Bible-tamil-main/3%2520John.json": "0c7af08f7de7aac9b343ce22c616e977",
"assets/assets/Bible-tamil-main/Acts.json": "e763bdc06e6041e8b6f7550cfc15b029",
"assets/assets/Bible-tamil-main/Amos.json": "87e059317f62c16c49310b436b216df0",
"assets/assets/Bible-tamil-main/Books.json": "cb8d81a7b132e6f04e919cceeb29ec84",
"assets/assets/Bible-tamil-main/Colossians.json": "3a0b443dbad1ee2d52e902e9074f9542",
"assets/assets/Bible-tamil-main/Daniel.json": "bf0831bc6ac7a67019867b5d768fbf3b",
"assets/assets/Bible-tamil-main/Deuteronomy.json": "0f746e7fd73c3d24706cddc9df45d402",
"assets/assets/Bible-tamil-main/Ecclesiastes.json": "49102c0556ee0ce01236a10110b2ff99",
"assets/assets/Bible-tamil-main/Ephesians.json": "f6d075137cdcdda52a0273cf4e0dba03",
"assets/assets/Bible-tamil-main/Esther.json": "3263e7d79816a198ebac981ed0451f33",
"assets/assets/Bible-tamil-main/Exodus.json": "d001949c17731c960e32a83413130e78",
"assets/assets/Bible-tamil-main/Ezekiel.json": "712a6a99ebbeb2ea5c733bb09f550ca6",
"assets/assets/Bible-tamil-main/Ezra.json": "5e9832e072f95073bd5c3c4693a48df7",
"assets/assets/Bible-tamil-main/Galatians.json": "16ba5a551a354a8ac106f8b101f1f738",
"assets/assets/Bible-tamil-main/Genesis.json": "01d4651969648d10589d81bf2b11be8d",
"assets/assets/Bible-tamil-main/Habakkuk.json": "d4f0ee17997471cf6fd8cd28fba2df6e",
"assets/assets/Bible-tamil-main/Haggai.json": "1407ab2e698cdd13f6b33bb37efc7db6",
"assets/assets/Bible-tamil-main/Hebrews.json": "705ae0b0750bfd361d0f10d96d4e4933",
"assets/assets/Bible-tamil-main/Hosea.json": "7db786300722ad57e12ec5ed7cbe787a",
"assets/assets/Bible-tamil-main/Isaiah.json": "50124b974d8d60fe5a20e41edb5c3eb5",
"assets/assets/Bible-tamil-main/James.json": "c17edafd858850c81a902f4d0aef97f0",
"assets/assets/Bible-tamil-main/Jeremiah.json": "ea9465305d66879d2c0e7a7a380c8d47",
"assets/assets/Bible-tamil-main/Job.json": "bdea59d86e2e39132a3c12cfc02212d2",
"assets/assets/Bible-tamil-main/Joel.json": "3d59bafd5c1b9eb6e96edc9979e0867c",
"assets/assets/Bible-tamil-main/John.json": "0fdee7cf857c65a3ec1d433e2552fbdf",
"assets/assets/Bible-tamil-main/Jonah.json": "10635fb6b86307b59c51e5bd544accb1",
"assets/assets/Bible-tamil-main/Joshua.json": "223a79f77556b696b0f1538ded305580",
"assets/assets/Bible-tamil-main/Jude.json": "44bea022aa4ebe03b93cd4a5baa40fd5",
"assets/assets/Bible-tamil-main/Judges.json": "767aae81788d18e4df611a95bbb80133",
"assets/assets/Bible-tamil-main/Lamentations.json": "6d1bdc15380e3a5166fc7ec083103545",
"assets/assets/Bible-tamil-main/Leviticus.json": "1a5c0b0b79d69a62f60142cb48fe3e3b",
"assets/assets/Bible-tamil-main/Luke.json": "270ae1493b41aaa07a9b17cc8185f575",
"assets/assets/Bible-tamil-main/Malachi.json": "f45cfc67facf3654a01a0fbe2c4146f2",
"assets/assets/Bible-tamil-main/Mark.json": "c5baf68424579cea71ee4e0d256830cb",
"assets/assets/Bible-tamil-main/Matthew.json": "88935e835ba59cf355ff0213ac4344e5",
"assets/assets/Bible-tamil-main/Micah.json": "47af22ea5a1c5baa663dead546f56676",
"assets/assets/Bible-tamil-main/Nahum.json": "20f723bc35286aa4cc363dc1cf7bb96a",
"assets/assets/Bible-tamil-main/Nehemiah.json": "bacb9d24ff3e8b2e94c8ef967bda1a57",
"assets/assets/Bible-tamil-main/Numbers.json": "b5ab15d66fae7a146069161d198904d2",
"assets/assets/Bible-tamil-main/Obadiah.json": "3f76372dccfb209deca04a7178ef8203",
"assets/assets/Bible-tamil-main/Philemon.json": "120175b4f2dd20a0fc24dc802389503b",
"assets/assets/Bible-tamil-main/Philippians.json": "f59a0e67b6d201b86d609e5530860d77",
"assets/assets/Bible-tamil-main/Proverbs.json": "c61575889a7de7aec1e3bcf87e34e6e3",
"assets/assets/Bible-tamil-main/Psalms.json": "feda1cad850dfb51657adc4df10b77a6",
"assets/assets/Bible-tamil-main/Revelation.json": "a18095034dc12c7cde38b5d1f8956fb3",
"assets/assets/Bible-tamil-main/Romans.json": "1e970d8a881ac962bb795792c8b9a219",
"assets/assets/Bible-tamil-main/Ruth.json": "f0ecf7de0cc43761944335abe09194fe",
"assets/assets/Bible-tamil-main/Song%2520of%2520Songs.json": "319fc774579de705475556ba786dfd89",
"assets/assets/Bible-tamil-main/Titus.json": "ff7cb558dc2b4f0c69f47394c8191142",
"assets/assets/Bible-tamil-main/Zechariah.json": "6404e67ff952d5e54a285804aafc6148",
"assets/assets/Bible-tamil-main/Zephaniah.json": "6f72a88635cf427bb5a0b847a2db8fb5",
"assets/assets/bible.png": "b96f3c948444ce3f3ce04066cb606bf1",
"assets/assets/bibleshop.png": "ae30d0451519d58c89a64482002a2dbb",
"assets/assets/church.png": "e4c21cfae6af69089f237d657bdc1043",
"assets/assets/CSI%2520Christ%2520Church.png": "defcabcd91072259080a20027bb43fdd",
"assets/assets/csi-st-thomas-church-10292362.png": "3eb71d50d71332a3f99315403cd408a6",
"assets/assets/gallery.png": "311378f197a3c44a55376dd1e59a906f",
"assets/assets/logo.png": "12bef665a1329379641c4576c1ec7636",
"assets/assets/Noto_Sans/NotoSans-Italic-VariableFont_wdth,wght.ttf": "57b81d1ff243238df110e225d8891400",
"assets/assets/Noto_Sans/NotoSans-VariableFont_wdth,wght.ttf": "b72e420edb95cdf06e6e0a27bc0d964d",
"assets/assets/Noto_Sans/OFL.txt": "2e3a777b99ade88bf4b23a103dabf96c",
"assets/assets/Noto_Sans/README.txt": "3786be7e5536d35a374de3edf9b48def",
"assets/assets/Noto_Sans/static/NotoSans-Regular.ttf": "f46b08cc90d994b34b647ae24c46d504",
"assets/assets/profile_pic.png": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/scarf.png": "f236058a5f938b8250ec2f9cba2aa71d",
"assets/assets/songbook.png": "8027a25627209c7d324ceaa1b7d6d53f",
"assets/assets/songs.png": "aaac8cf8762e657e08f2db88f09a0edd",
"assets/assets/sothirabaligal.json": "3f0a599302547d9ad0e8dc84af03031f",
"assets/assets/success_tick.json": "6be0d95d8e47281dcd22fa04035ccfc4",
"assets/assets/upheld-setting-454612-f1-bd01f9fd2fa2.json": "da18ef09c00de15882c1c555a5d51503",
"assets/assets/versecards.png": "b71c9695874536be54439d6e6647647e",
"assets/assets/video.png": "b9b1badd768f017230060d21f219f33e",
"assets/assets/youtubelogo.png": "7f0e69d02413e135558820f1ec96c99f",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "77a521ac9be0d37bfce0bf7b462d8a47",
"assets/NOTICES": "4ea39aca8386a8790ccf0e2935ad229c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/flutter_sound/assets/js/async_processor.js": "1665e1cb34d59d2769956d2f14290274",
"assets/packages/flutter_sound/assets/js/tau_web.js": "32cc693445f561133647b10d1b97ca07",
"assets/packages/flutter_sound_web/howler/howler.js": "3030c6101d2f8078546711db0d1a24e9",
"assets/packages/flutter_sound_web/src/flutter_sound.js": "3c26fcc60917c4cbaa6a30a231f7d4d8",
"assets/packages/flutter_sound_web/src/flutter_sound_player.js": "b14f8d190230d77c02ffc51ce962ce80",
"assets/packages/flutter_sound_web/src/flutter_sound_recorder.js": "0ec45f8c46d7ddb18691714c0c7348c8",
"assets/packages/flutter_sound_web/src/flutter_sound_stream_processor.js": "48d52b8f36a769ea0e90cf9e58eddfa7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "6e3f8f3ac69d39dade49d1aefe210125",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "a95c67267f37db44950da89e9ecd7914",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/logo.png": "12bef665a1329379641c4576c1ec7636",
"index.html": "d3547d5041a57bd2c4fe32864827ff75",
"/": "d3547d5041a57bd2c4fe32864827ff75",
"main.dart.js": "c6fecbf7063378701d660b8e1a252902",
"manifest.json": "f89b2b024bd3cff94143817f48892d9e",
"sqflite_sw.js": "fed9e557a03badca73d99bbc6a6b033c",
"version.json": "b984da15e102a8971c74f8eb4b054ea4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
