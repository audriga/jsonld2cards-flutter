<?php
cors();

# Check for path parameter, and prevent file transfer
if (isset($_GET['path'])) {
    $path = $_GET['path'];
} else {
    header('HTTP/1.1 404 Not Found');
    exit;
}

$body = '{
  "@context": "http://schema.googleapis.com/",
  "@type": "MusicAlbum",
  "@id": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "url": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "name": "Semantics",
  "description": "' .$path. '",
  "datePublished": "2022-08-19",
  "potentialAction": {
    "@type": "ListenAction",
    "target": [
      {
        "@type": "EntryPoint",
        "urlTemplate": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu?autoplay=true",
        "actionPlatform": [
          "http://schema.org/DesktopWebPlatform",
          "http://schema.org/IOSPlatform",
          "http://schema.googleapis.com/GoogleAudioCast",
          "http://schema.googleapis.com/GoogleVideoCast"
        ]
      },
      "android-app://com.spotify.music/spotify/album/4F1fUukNCGBD5YjDViOJtu/play"
    ],
    "expectsAcceptanceOf": {
      "@type": "Offer",
      "category": "free",
      "eligibleRegion": [
        {
          "@type": "Country",
          "name": "AD"
        },
        {
          "@type": "Country",
          "name": "ZW"
        }
      ]
    }
  }
}';

echo $body;
exit;

//https://stackoverflow.com/a/9866124
function cors() {

    // Allow from localhost
    if (isset($_SERVER['HTTP_ORIGIN']) and preg_match('#^https?://localhost#', $_SERVER['HTTP_ORIGIN']) === 1) {
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Max-Age: 86400');    // cache for 1 day
    }

    // Access-Control headers are received during OPTIONS requests
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
            // may also be using POST PUT, PATCH, HEAD etc
            header("Access-Control-Allow-Methods: GET, OPTIONS");

        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
            header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

        exit(0);
    }
}