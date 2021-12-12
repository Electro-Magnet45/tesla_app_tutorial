import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tesla_animated_app/constanins.dart';
import 'package:tesla_animated_app/home_controller.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/temp_details.dart';
import 'components/tesla_navigationbar.dart';
import 'components/tyres.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _batteryAnimController, _tempAnimationController;
  late Animation<double> _animationBattery,
      _animBatteryStatus,
      _animationCarShift,
      _animTempShowInfo,
      _animationCoolGlow;

  void setUpBatteryAnim() {
    _batteryAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationBattery = CurvedAnimation(
        parent: _batteryAnimController, curve: const Interval(0.0, 0.5));

    _animBatteryStatus = CurvedAnimation(
        parent: _batteryAnimController, curve: const Interval(0.6, 1));
  }

  void setUpTempAnim() {
    _tempAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animationCarShift = CurvedAnimation(
        parent: _tempAnimationController, curve: const Interval(0.2, 0.4));
    _animTempShowInfo = CurvedAnimation(
        parent: _tempAnimationController, curve: const Interval(0.45, 0.65));
    _animationCoolGlow = CurvedAnimation(
        parent: _tempAnimationController, curve: const Interval(0.7, 1));
  }

  @override
  void initState() {
    setUpBatteryAnim();
    setUpTempAnim();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimController.dispose();
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge(
            [_controller, _batteryAnimController, _tempAnimationController]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaNavigationBar(
                onTap: (index) {
                  if (index == 1)
                    _batteryAnimController.forward();
                  else if (_controller.selectedBottomTab == 1 && index != 1)
                    _batteryAnimController.reverse(from: 0.7);
                  if (index == 2)
                    _tempAnimationController.forward();
                  else if (_controller.selectedBottomTab == 2 && index != 2)
                    _tempAnimationController.reverse(from: 0.4);

                  _controller.showTyreContr(index);
                  _controller.onBottomTabChange(index);
                },
                selectedTab: _controller.selectedBottomTab),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constrains) {
                //to get constrains
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: constrains.maxHeight,
                        width: constrains.maxWidth),
                    Positioned(
                      left: constrains.maxWidth / 2 * _animationCarShift.value,
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: constrains.maxHeight * 0.1),
                        child: SvgPicture.asset(
                          "assets/icons/Car.svg",
                          width: double.infinity,
                        ),
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
                    ),
                    Positioned(
                        height: constrains.maxHeight,
                        width: constrains.maxWidth,
                        top: 60 * (1 - _animTempShowInfo.value),
                        child: Opacity(
                            opacity: _animTempShowInfo.value,
                            child: TempDetails(controller: _controller))),
                    Positioned(
                        right: -180 * (1 - _animationCoolGlow.value),
                        child: AnimatedSwitcher(
                          duration: defaultDuration,
                          child: _controller.isCoolSelected
                              ? Image.asset("assets/images/Cool_glow_2.png",
                                  key: UniqueKey(), width: 200)
                              : Image.asset("assets/images/Hot_glow_4.png",
                                  key: UniqueKey(), width: 190),
                        )),
                    if (_controller.isShowTyre) ...tyres(constrains),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: 4,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: defaultPadding,
                                  crossAxisSpacing: defaultPadding,
                                  childAspectRatio: constrains.maxWidth /
                                      constrains.maxHeight),
                          itemBuilder: (context, index) => Container(
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: primaryColor, width: 2)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(TextSpan(
                                        text: "23.6",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                        children: const [
                                          TextSpan(
                                              text: "psi",
                                              style: TextStyle(fontSize: 24))
                                        ])),
                                    const SizedBox(height: defaultPadding),
                                    const Text(
                                      "41\u2103",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Low".toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Presure".toUpperCase(),
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              )),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
