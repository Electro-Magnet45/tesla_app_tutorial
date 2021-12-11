import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constanins.dart';
import 'package:tesla_animated_app/home_controller.dart';
import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/tesla_navigationbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _batteryAnimController;
  late Animation<double> _animationBattery;
  late Animation<double> _animBatteryStatus;

  void setUpBatteryAnim() {
    _batteryAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationBattery = CurvedAnimation(
        parent: _batteryAnimController, curve: const Interval(0.0, 0.5));

    _animBatteryStatus = CurvedAnimation(
        parent: _batteryAnimController, curve: const Interval(0.6, 1));
  }

  @override
  void initState() {
    setUpBatteryAnim();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([_controller, _batteryAnimController]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaNavigationBar(
                onTap: (index) {
                  if (index == 1)
                    _batteryAnimController.forward();
                  else if (_controller.selectedBottomTab == 1 && index != 1)
                    _batteryAnimController.reverse(from: 0.7);
                  _controller.onBottomTabChange(index);
                },
                selectedTab: _controller.selectedBottomTab),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constrains) {
                //to get constrains
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: constrains.maxHeight * 0.1),
                      child: SvgPicture.asset(
                        "assets/icons/Car.svg",
                        width: double.infinity,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.13
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.17
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _batteryAnimController.value,
                      child: SvgPicture.asset('assets/icons/Battery.svg',
                          width: constrains.maxWidth * 0.45),
                    ),
                    Positioned(
                      top: 50 * (1 - _animBatteryStatus.value),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Opacity(
                          opacity: _animBatteryStatus.value,
                          child: BatteryStatus(constrains: constrains)),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
