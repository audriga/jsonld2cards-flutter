library schema_types;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/Cards/Models/music_model.dart';
import 'package:jsonld2cards/Cards/Models/order_model.dart';
import 'package:jsonld2cards/Cards/Models/parcel_delivery_model.dart';
import 'package:jsonld2cards/Cards/Models/action_model.dart' as schema_action;
import 'package:jsonld2cards/Cards/Models/place_model.dart';
import 'package:jsonld2cards/Cards/Models/thing_model.dart';

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
}

SchemaType? getCardType(String typeName) {
  return switch (typeName) {
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
    _ => null,
  };
}

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
  String get typeName => switch(this) {
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
    };

  /// Friendly names for the type to be displayed on tabs
  String get tabName {
    return switch(this) {
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
    };
  }

  IconData? get icon {
    return switch(this) {
      SchemaType.emailMessage => Icons.mail,
      SchemaType.place => Icons.place,
      SchemaType.musicRecording => Icons.music_note,
      SchemaType.musicGroup => Icons.queue_music,
      SchemaType.musicAlbum => Icons.album,
      SchemaType.flightReservation => Icons.flight,
      SchemaType.order => Icons.shopping_bag,
      SchemaType.invoice => Icons.receipt,
      SchemaType.parcelDelivery => Icons.local_shipping,
      SchemaType.blogPosting => Icons.receipt, // Todo
      SchemaType.itemList => Icons.list,
      SchemaType.confirmAction => Icons.check_circle,
      SchemaType.cancelAction => Icons.cancel,
      SchemaType.action => Icons.directions_run,
      SchemaType.bakery => Icons.bakery_dining,
    };
  }

  /// Returns true if and only if there exists a card template for this type.
  bool get isSimpleTemplatedType => [
    SchemaType.bakery,
  ].contains(this);

  /// Returns true if and only if there exists a card template for this type.
  bool get isThreeColumnTemplatedType => [
  ].contains(this);

   int duplicateHash(Map<String, dynamic> json) => switch(this) {
    // SchemaType.emailMessage => 'EmailMessage',
    SchemaType.place => Place.fromJson(json).duplicateHash,
    SchemaType.musicRecording => MusicRecording.fromJson(json).duplicateHash,
    SchemaType.musicGroup => MusicGroup.fromJson(json).duplicateHash,
    SchemaType.musicAlbum => MusicAlbum.fromJson(json).duplicateHash,
    // SchemaType.flightReservation => 'FlightReservation',
    SchemaType.order => Order.fromJson(json).duplicateHash,
    SchemaType.invoice => Invoice.fromJson(json).duplicateHash,
    SchemaType.parcelDelivery => ParcelDelivery.fromJson(json).duplicateHash,
    // SchemaType.blogPosting => 'BlogPosting',
    SchemaType.itemList => ItemList.fromJson(json).duplicateHash,
    SchemaType.confirmAction => schema_action.Action.fromJson(json).duplicateHash,
    SchemaType.cancelAction => schema_action.Action.fromJson(json).duplicateHash,
    SchemaType.action => schema_action.Action.fromJson(json).duplicateHash,
     _ => Thing.fromJson(json).duplicateHash,
  };
}
