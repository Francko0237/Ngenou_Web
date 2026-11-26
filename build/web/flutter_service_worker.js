'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/webparagraph/canvaskit.js": "d1037ee4a7e59f39a341e7a220fd09d7",
"canvaskit/webparagraph/canvaskit.js.symbols": "c8cfd336f56d2dc99bb77939c1b485af",
"canvaskit/webparagraph/canvaskit.wasm": "0a6920d986be45bf35d53b001a07fc77",
"canvaskit/wimp.js": "0f59c28e92c43474b446c202b35892c2",
"canvaskit/wimp.js.symbols": "325820d52878cf32e22b7609fd8fd2b2",
"canvaskit/wimp.wasm": "c8a7a40d867c889dd5a88dbdabadd8a3",
"assets/assets/images/logo.png": "343f0e36d5f49513c3abcedd970b6b30",
"assets/assets/images/logo_full.png": "3b3c90d24e27f63051bbf6a5c15cf25a",
"assets/assets/screenshots/%25E2%2580%2594Pngtree%25E2%2580%2594cell%2520phone%2520mockup_8987534.png": "5fb5733eced3cbe25724472cd6e10681",
"assets/assets/screenshots/Assets1.png": "e48843ad15bd59fd4fb54317d6d8ae36",
"assets/assets/screenshots/Assets2.png": "e0a47e86c1c7cdddc38dc94719024454",
"assets/assets/screenshots/Cours.png": "b94f7a9872c98270a1701ca928e5e6ce",
"assets/assets/screenshots/Dashboard.png": "c7592244481c12e69a235840732af6a8",
"assets/assets/screenshots/Defis1.png": "a8bb918324e043a33d5155196884bfca",
"assets/assets/screenshots/Defis2.png": "bec2bb5c93a43f670868f901a68483b7",
"assets/assets/screenshots/EmploieDEtemps2.png": "20825e336762426e7398b5ab17cb0b00",
"assets/assets/screenshots/EmploieDetemps1.png": "5e4d034f17ce08eb06931c6e5ae2aeb4",
"assets/assets/screenshots/Ngenou2.png": "18dff91dc30795a14107b867da574cb9",
"assets/assets/screenshots/phone_frame.png": "9f7a4a9ee9f1669f970bdc67039ce975",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/material_ui/shaders/ink_sparkle.frag": "2815c3cf1e7af2d8a2d328064a62e3a0",
"assets/fonts/MaterialIcons-Regular.otf": "5a2eb7facb461455e65edda254ad0cb2",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "2c6260bcc446eaae66e6478af629f958",
"assets/AssetManifest.bin.json": "f0fc79a38549f6486fbc6b7aea685c39",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "100cd20dea0a115c3ecfb6fdd839041d",
"icons/Icon-192.png": "343f0e36d5f49513c3abcedd970b6b30",
"icons/Icon-512.png": "343f0e36d5f49513c3abcedd970b6b30",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"Ngenou.apk": "3c6ae2840a2d5ed87a1214b1f1b80099",
"favicon.png": "343f0e36d5f49513c3abcedd970b6b30",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter.js.map": "dc4c394199e37bc66a70f7c431248458",
"flutter_bootstrap.js": "a21ed7040ca79ee91b4e5442e81961e8",
"index.html": "0b66fe3fd38ce0849d007b6e610fae16",
"/": "0b66fe3fd38ce0849d007b6e610fae16",
"main.dart.js": "aac5db587ccbfb5b9267a4fed73173b7",
"manifest.json": "9691b5cad869b42e6aab35c876bc6e03",
"robots.txt": "50b48ac48dbf85f994ea12545d5a1a61",
"sitemap.xml": "cb39dd4cc58ee8a137cc147334a8df2f",
"version.json": "482df74bdee37e1cedcd228cc17b6458",
"vercel.json": "51e09378cce7591b49d78049497e4da9"};
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
