<?php
cors();

# Check for path parameter, and prevent file transfer
if (isset($_GET['path'])) {
    $path = $_GET['path'];
} else {
    header('HTTP/1.1 404 Not Found');
    exit;
}

$body = '[{
  "@context": "http://schema.org/",
  "@type": "Organization",


  "logo": "https://www.gstatic.com/images/branding/product/1x/googleg_48dp.png"
},{
  "@context": "http://schema.org/",
  "@type": "EmailMessage",

  "subjectLine": "[Important] Please add subject line in annotation"
},{
  "@context": "http://schema.org/",
  "@type": "DiscountOffer",

  "description": "20% off",

  "discountCode": "PROMO",
  "availabilityStarts": "2023-06-14T04:51:14-07:00",
  "availabilityEnds": "2023-06-17T04:51:14-07:00"
},{
  "@context": "http://schema.org/",
  "@type": "PromotionCard",
  "image": "https://www.google.com/gmail-for-marketers/promo-tab/markup-tool/glasses.jpg",
  "url": "https://google.com",

  "headline": "Glasses",
  "price": 149,
  "priceCurrency": "USD",
  "discountValue": 30,
  "position": 1
},{
  "@context": "http://schema.org/",
  "@type": "PromotionCard",
  "image": "https://www.google.com/gmail-for-marketers/promo-tab/markup-tool/ski-boots.jpg",
  "url": "https://google.com",
  "headline": "Ski boots",
  "price": 249,
  "priceCurrency": "USD",
  "discountValue": 50,
  "position": 2
},{
  "@context": "http://schema.org/",
  "@type": "PromotionCard",
  "image": "https://www.google.com/gmail-for-marketers/promo-tab/markup-tool/sneakers.jpg",
  "url": "https://google.com",
  "headline": "Sneakers",
  "price": 179,
  "priceCurrency": "USD",
  "discountValue": 30,
  "position": 3
}]';

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