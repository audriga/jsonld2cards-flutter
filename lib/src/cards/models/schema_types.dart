library;

import 'package:flutter/material.dart';
import 'music_model.dart';
import 'order_model.dart';
import 'parcel_delivery_model.dart';
import 'action_model.dart' as schema_action;
import 'place_model.dart';
import 'simple_poll_model.dart';
import 'thing_model.dart';
// import 'promo_tab_card.dart';

import 'invoice_model.dart';
import 'item_list_model.dart';

enum SchemaType {
  emailMessage,
  place,
  musicRecording,
  musicGroup,
  musicAlbum,
  flightReservation,
  order,
  invoice,
  parcelDelivery,
  blogPosting,
  itemList,
  confirmAction,
  cancelAction,
  action,
  bakery,
  cafeOrCoffeeShop,
  iceCreamShop,
  promotionCard,
  event,
  simplePoll,
}

SchemaType? getCardType(String typeName) => switch (typeName) {
      'EmailMessage' => SchemaType.emailMessage,
      'Place' => SchemaType.place,
      'MusicRecording' => SchemaType.musicRecording,
      'MusicGroup' => SchemaType.musicGroup,
      'MusicAlbum' => SchemaType.musicAlbum,
      'FlightReservation' => SchemaType.flightReservation,
      'Order' => SchemaType.order,
      'Invoice' => SchemaType.invoice,
      'ParcelDelivery' => SchemaType.parcelDelivery,
      'BlogPosting' => SchemaType.blogPosting,
      'ItemList' => SchemaType.itemList,
      'ConfirmAction' => SchemaType.confirmAction,
      'CancelAction' => SchemaType.cancelAction,
      'Action' => SchemaType.action,
      'Bakery' => SchemaType.bakery,
      'CafeOrCoffeeShop' => SchemaType.cafeOrCoffeeShop,
      'IceCreamShop' => SchemaType.iceCreamShop,
      'PromotionCard' => SchemaType.promotionCard,
      'Event' => SchemaType.event,
      'SimplePoll' => SchemaType.simplePoll,
      _ => null,
    };

extension SchemaTypeName on SchemaType {
  // String get name {
  //   switch(this) {
  //     case SchemaType.emailMessage: return 'EmailMessage';
  //     case SchemaType.place: return 'Place';
  //
  //     default: return "";
  //   }
  // }

  /// Reverse of [getCardType]
  String get typeName => switch (this) {
        SchemaType.emailMessage => 'EmailMessage',
        SchemaType.place => 'Place',
        SchemaType.musicRecording => 'MusicRecording',
        SchemaType.musicGroup => 'MusicGroup',
        SchemaType.musicAlbum => 'MusicAlbum',
        SchemaType.flightReservation => 'FlightReservation',
        SchemaType.order => 'Order',
        SchemaType.invoice => 'Invoice',
        SchemaType.parcelDelivery => 'ParcelDelivery',
        SchemaType.blogPosting => 'BlogPosting',
        SchemaType.itemList => 'ItemList',
        SchemaType.confirmAction => 'ConfirmAction',
        SchemaType.cancelAction => 'CancelAction',
        SchemaType.action => 'Action',
        SchemaType.bakery => 'Bakery',
        SchemaType.cafeOrCoffeeShop => 'CafeOrCoffeeShop',
        SchemaType.iceCreamShop => 'IceCreamShop',
        SchemaType.promotionCard => 'PromotionCard',
        SchemaType.event => 'Event',
        SchemaType.simplePoll => 'SimplePoll',
      };

  /// Friendly names for the type to be displayed on tabs
  String get tabName => switch (this) {
        SchemaType.emailMessage => 'Email Message',
        SchemaType.place => 'Place',
        SchemaType.musicRecording => 'Song',
        SchemaType.musicGroup => 'Music',
        SchemaType.musicAlbum => 'Album',
        SchemaType.flightReservation => 'Flight Reservation',
        SchemaType.order => 'Order',
        SchemaType.invoice => 'Invoice',
        SchemaType.parcelDelivery => 'Parcel',
        SchemaType.blogPosting => 'Post',
        SchemaType.itemList => 'List',
        SchemaType.confirmAction => 'Confirmation',
        SchemaType.cancelAction => 'Cancellation',
        SchemaType.action => 'Action',
        SchemaType.bakery => 'Bakery',
        SchemaType.cafeOrCoffeeShop => 'Café',
        SchemaType.iceCreamShop => 'Ice Cream Place',
        SchemaType.promotionCard => 'Promotion',
        SchemaType.event => 'Event',
        SchemaType.simplePoll => 'Poll',
      };

  IconData? get icon => switch (this) {
        SchemaType.emailMessage => Icons.mail,
        SchemaType.place => Icons.place,
        SchemaType.musicRecording => Icons.music_note,
        SchemaType.musicGroup => Icons.queue_music,
        SchemaType.musicAlbum => Icons.album,
        SchemaType.flightReservation => Icons.flight,
        SchemaType.order => Icons.shopping_bag,
        SchemaType.invoice => Icons.receipt,
        SchemaType.parcelDelivery => Icons.local_shipping,
        SchemaType.blogPosting => Icons.newspaper,
        SchemaType.itemList => Icons.list,
        SchemaType.confirmAction => Icons.check_circle,
        SchemaType.cancelAction => Icons.cancel,
        SchemaType.action => Icons.directions_run,
        SchemaType.bakery => Icons.bakery_dining,
        SchemaType.cafeOrCoffeeShop => Icons.local_cafe,
        SchemaType.iceCreamShop => Icons.icecream,
        SchemaType.promotionCard => Icons.shop,
        SchemaType.event => Icons.event,
        SchemaType.simplePoll => Icons.poll,
      };

  /// Returns true if and only if there exists a card template for this type.
  bool get isSimpleTemplatedType => simpleTemplateTypes.contains(this);

  /// Returns true if and only if there exists a card template for this type.
  bool get isThreeColumnTemplatedType =>
      threeColumnTemplateTypes.contains(this);

  int duplicateHash(Map<String, dynamic> json) => switch (this) {
        // SchemaType.emailMessage => 'EmailMessage',
        SchemaType.place => Place.fromJson(json).duplicateHash,
        SchemaType.musicRecording =>
          MusicRecording.fromJson(json).duplicateHash,
        SchemaType.musicGroup => MusicGroup.fromJson(json).duplicateHash,
        SchemaType.musicAlbum => MusicAlbum.fromJson(json).duplicateHash,
        // SchemaType.flightReservation => 'FlightReservation',
        SchemaType.order => Order.fromJson(json).duplicateHash,
        SchemaType.invoice => Invoice.fromJson(json).duplicateHash,
        SchemaType.parcelDelivery =>
          ParcelDelivery.fromJson(json).duplicateHash,
        // SchemaType.blogPosting => 'BlogPosting',
        SchemaType.itemList => ItemList.fromJson(json).duplicateHash,
        SchemaType.confirmAction =>
          schema_action.Action.fromJson(json).duplicateHash,
        SchemaType.cancelAction =>
          schema_action.Action.fromJson(json).duplicateHash,
        SchemaType.action => schema_action.Action.fromJson(json).duplicateHash,
        SchemaType.simplePoll => SimplePoll.fromJson(json).duplicateHash,
        // SchemaType.promotionCard => PromotionCardData.fromJson(json).duplicateHash,
        _ => Thing.fromJson(json).duplicateHash,
      };
}

const simpleTemplateTypes = [
  SchemaType.bakery,
  SchemaType.cafeOrCoffeeShop,
  SchemaType.iceCreamShop
];
const threeColumnTemplateTypes = [];
