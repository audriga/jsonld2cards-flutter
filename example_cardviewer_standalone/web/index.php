<?php
cors();

# Check for path parameter
if (isset($_GET['cardId'])) {
    $cardId = $_GET['cardId'];
}

$jsonld = '{
  "@context": "http://schema.org",
  "@type": "Organization",
  "url": "https://www.audriga.com",
  "name": "audriga"
}';
$pathSegments = explode("/", $cardId);
if (count($pathSegments) > 1) {
    // Someone is trying to access a card where they shouldn't be.
    // Potentially malicious (like ../../../../../etc/passwd). Not using given cardId.
    // Below commented out is some debug json
//     $jsonld = '{
//   "@context": "http://schema.org",
//   "@type": "Organization",
//   "url": "https://www.audriga.com",
//   "name": "audriga",
//   "pathSegments": "'. $pathSegments . '",
//   "cardId": "' . $cardId . '"
// }';
} else {
    $filename = '../data/' . $cardId . '.json';
    $path = realpath($filename);
    if ($path) {
        if (file_exists($path)){
            $jsonld = file_get_contents($path);
        }
    } else {
        // Below is debug info. Don't include in actual output
//         $jsonld = '{
//   "@context": "http://schema.org",
//   "@type": "Organization",
//   "url": "https://www.audriga.com",
//   "name": "audriga",
//   "details": "'. $path . ' is false?",
//   "filename": "' . $filename . '"
// }';
    }
}


$html = file_get_contents('flutter_index.html');
$dom = new DOMDocument;
$dom->loadHTML($html);
$new_elm = $dom->createElement('script', $jsonld);
$new_elm->setAttribute('type', 'application/ld+json');
$head = $dom->getElementsByTagName('head')->item(0);
$head->appendChild($new_elm);

echo $dom->saveHTML();




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