<?php
cors();

# Check for path parameter
if (isset($_GET['path'])) {
    $inputPath = $_GET['path'];
}

$html = file_get_contents('index.html');
$dom = new DOMDocument;
$dom->loadHTML($html);
$new_elm = $dom->createElement('script', '{
  "@context": "http://schema.org",
  "@type": "Organization",
  "url": "http://www.your-company-site.com",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-401-555-1212",
    "contactType": "customer service"
  }
}');
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