library schema_types;

import 'package:flutter/material.dart';

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
    };
  }
}
