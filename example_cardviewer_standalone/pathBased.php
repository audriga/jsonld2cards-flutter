<?php
cors();

# Check for path parameter
if (isset($_GET['path'])) {
    $inputPath = $_GET['path'];
} else {
    header('HTTP/1.1 404 Not Found');
//    $body = 'path not set';
//    echo $body;
    exit;
}




// As per https://stackoverflow.com/questions/1911382/sanitize-file-path-in-php
// using realpath, to get rid of any .. directives.
// Note: Will also return false if the file does not exist, so any processing to the path
// has to be done beforehand. In this case we just attach the .json ending
$filename = $inputPath . '.json';
$path = realpath($filename);
if ($path) {
    // Making sure can't access anything above the current directory.
    // As for an input of ../../../../../etc/passwd realpath would return /etc/passwd.

    // maybe even replace this with some sub-folder
    $sanitizedPath = './' . $path;
    if (file_exists($path)){
        $body = file_get_contents($filename);
        echo $body;
        exit;
    }
    header('HTTP/1.1 404 Not Found');
    exit;
}


$pathSegments = explode("/", $inputPath);

if ($pathSegments[0] != "mock") {
    header('HTTP/1.1 404 Not Found');
//    $body = 'no such file and not mock';
//    echo $body;
    exit;
}

switch ($pathSegments[1]) {
    case "music" : {
        $body = '{
  "@context": "http://schema.googleapis.com/",
  "@type": "MusicAlbum",
  "@id": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "url": "https://open.spotify.com/album/4F1fUukNCGBD5YjDViOJtu",
  "name": "Semantics",
  "description": "This is a mock card",
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
    }
    case "location" : {
        $body = '{
  "@context": "https://schema.org",
  "@type": "Place",
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "40.75",
    "longitude": "-73.98"
  },
  "name": "Empire State Building"
}';
        echo $body;
        exit;
    }
    case "invoice" :
        $body = '{
  "@context": "http://schema.org",
  "@type": "Invoice",
  "accountId": "123-456-789",
  "minimumPaymentDue": {
    "@type": "PriceSpecification",
    "price": "$70.00"
  },
  "paymentDue": "2013-11-22T08:00:00+00:00",
  "paymentStatus": "PaymentAutomaticallyApplied",
  "provider": {
    "@type": "Organization",
    "name": "Mountain View Utilities"
  },
  "totalPaymentDue": {
    "@type": "PriceSpecification",
    "price": "$70.00"
  }
}';
        echo $body;
        exit;
    default : {
        header('HTTP/1.1 404 Not Found');
        $body = 'default case';
        echo $body;
        exit;
    }
}




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