// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class SensorCard extends StatelessWidget {

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;


  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: AppTheme.surface,

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: AppTheme.border,
        ),

      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          Container(

            padding:
            const EdgeInsets.all(10),

            decoration: BoxDecoration(

              color:
              color.withOpacity(0.15),

              borderRadius:
              BorderRadius.circular(14),

            ),


            child: Icon(

              icon,

              color: color,

              size: 25,

            ),

          ),


          const Spacer(),


          Row(

            crossAxisAlignment:
            CrossAxisAlignment.end,


            children: [


              Text(

                value,

                style:
                TextStyle(

                  fontSize: 32,

                  fontWeight:
                  FontWeight.bold,

                  color: color,

                ),

              ),


              const SizedBox(width:5),


              Text(

                unit,

                style:
                const TextStyle(

                  color:
                  AppTheme.textSecondary,

                  fontSize:14,

                ),

              ),

            ],

          ),



          const SizedBox(height:8),



          Text(

            title,

            style:
            const TextStyle(

              color:
              AppTheme.textSecondary,

              fontSize:14,

            ),

          )

        ],

      ),

    );

  }

}