library split_button;

import 'package:flutter/material.dart';
import 'package:jsonld2cards/sml_app_context.dart';

typedef SplitButtonCallback = Function(String option);

class ForwardButton extends StatefulWidget {
  final SplitButtonCallback onTap;

  const ForwardButton({super.key, required this.onTap});

  @override
  State<ForwardButton> createState() => _ForwardButtonState();
}

class _ForwardButtonState extends State<ForwardButton> {
  late final Future<List<String>>? _forwardAddresses = getForwardAddresses();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _forwardAddresses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SplitButton(options: snapshot.data ?? [], onTap: widget.onTap);
        } else {
          return Container();
        }
      },
    );
  }

  Future<List<String>>? getForwardAddresses() {
    var forwardAddressesFunc = globalSMLAppContext?.forwardEmailAddresses;
    if (forwardAddressesFunc != null) {
      return forwardAddressesFunc();
    }
    return null;
  }
}

class SplitButton extends StatefulWidget {
  final SplitButtonCallback onTap;
  final List<String> options;

  const SplitButton({super.key, required this.onTap, required this.options});

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  late String? dropdownValue = widget.options.firstOrNull;
  late List<String> addresses = widget.options;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.forward_to_inbox),
        if (dropdownValue != null)
          TextButton(
              onPressed: () => widget.onTap(dropdownValue!),
              child: Text(dropdownValue!)),
        addresses.isNotEmpty
            ? MenuBar(
                children: [
                  SubmenuButton(
                    menuChildren: addresses
                        .map<MenuItemButton>((v) => MenuItemButton(
                              child: Text(v),
                              onPressed: () {
                                setState(() {
                                  dropdownValue = v;
                                });
                              },
                            ))
                        .toList(),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              )
            : TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Keine Ziele Konfiguriert'),
                      content: const Text(
                          'Rechnungen können an Kontakte, die eine xrechnung email hinertlegt haben weitergeleitet werden.'
                          'Hinterlegen Sie dafür bei einen Kontakt eine email addresse mit den label "xrechnug", und geben Sie dieser App die Berechtigung kontakte zu lesen.'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              globalSMLAppContext!.reloadContacts!();
                              var freshAddresses = await globalSMLAppContext!
                                  .forwardEmailAddresses!();
                              if (context.mounted) {
                                Navigator.pop(context, 'Ok');
                              }
                              if (freshAddresses.isNotEmpty) {
                                setState(() {
                                  addresses = freshAddresses;
                                  dropdownValue = addresses.first;
                                });
                              }
                            },
                            child: const Text('Kontakte neu laden')),
                        TextButton(
                            onPressed: () => Navigator.pop(context, 'Ok'),
                            child: const Text('Ok'))
                      ],
                    ),
                  );
                },
                child: const Text('Weiterleiten'),
              ),
        // DropdownMenu(
        //
        //   onSelected: (String? value){
        //     setState(() {
        //       dropdownValue = value!;
        //     });
        //   },
        //   dropdownMenuEntries: widget.options.map<DropdownMenuEntry<String>>((String value) {
        //     return DropdownMenuEntry<String>(
        //       value: value,
        //       // child: Text(value),
        //       // labelWidget: TextButton(onPressed: (){}, child: Text(value)),
        //       label: value,
        //     );
        //   }).toList(),
        //
        // ),
      ],
    );
  }
}
