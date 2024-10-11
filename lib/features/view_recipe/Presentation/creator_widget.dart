import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/Data/storage.dart';
import '../../../core/Presentation/resources/strings_manager.dart';

class CreatorWidget extends StatefulWidget {
  final int image;
  final String name;
  const CreatorWidget({Key? key, required this.image, required this.name}) : super(key: key);

  @override
  State<CreatorWidget> createState() => _CreatorWidgetState();
}

class _CreatorWidgetState extends State<CreatorWidget> {
  late Future<String?> getJwt;
  @override
  void initState() {
    getJwt = getjwt();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJwt,
        builder: ((context,snapshot){
      if(snapshot.hasData){
        return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 1), // Positions the shadow
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 35,
                  width: 35,
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                          "${AppString.SERVER_IP}/ukla/file-system/image/${widget.image}",
                          headers: {
                            'authorization': 'Bearer ${snapshot.data}',
                          },
                          fit: BoxFit.cover))),
              const SizedBox(width: 10.0),
              Text(
                widget.name,
                style:  TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }
      return Container();


    }));
  }
}



