[1mdiff --git a/README.md b/README.md[m
[1mindex e69de29..a9c4b28 100644[m
[1m--- a/README.md[m
[1m+++ b/README.md[m
[36m@@ -0,0 +1,220 @@[m
[32m+[m[32m# smartlab_project[m
[32m+[m
[32m+[m[32m> Clearpath Jackal (J100) customization package for **SmartLab** environment.[m
[32m+[m[32m> Based on Clearpath ROS 2 Humble framework with Gazebo Sim.[m
[32m+[m
[32m+[m[32m[![ROS 2](https://img.shields.io/badge/ROS_2-Humble-blue)](https://docs.ros.org/en/humble/)[m
[32m+[m[32m[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange)](https://releases.ubuntu.com/22.04/)[m
[32m+[m[32m[![Gazebo](https://img.shields.io/badge/Gazebo-Sim-green)](https://gazebosim.org/)[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 📌 프로젝트 개요[m
[32m+[m
[32m+[m[32m본 패키지는 SmartLab 연구 환경에 맞춰 커스터마이징된 **Clearpath Jackal (J100)** ROS 2 설정 패키지입니다.[m
[32m+[m[32m시뮬레이션과 실기 운용에 동일한 `robot.yaml` 구성을 사용하며, 향후 SmartLab 전용 환경(맵, 임무, 알고리즘)을 통합 관리합니다.[m
[32m+[m
[32m+[m[32m### 주요 목표[m
[32m+[m[32m- ✅ Jackal J100 시뮬레이션 환경 구축[m
[32m+[m[32m- ⏳ SmartLab 전용 Gazebo world 추가[m
[32m+[m[32m- ⏳ 자율주행 (Nav2) 통합[m
[32m+[m[32m- ⏳ 커스텀 임무 launch/config 작성[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 🤖 Robot Configuration[m
[32m+[m
[32m+[m[32m### Platform[m
[32m+[m[32m- **Model**: Jackal J100[m
[32m+[m[32m- **Battery**: HE2613 (S1P1)[m
[32m+[m[32m- **Controller**: PS4[m
[32m+[m[32m- **Top plate**: ARK Enclosure[m
[32m+[m[32m- **Fenders**: Sensor type (front + rear)[m
[32m+[m
[32m+[m[32m### Sensors[m
[32m+[m[32m| Type | Model | Mount | Frame ID |[m
[32m+[m[32m|---|---|---|---|[m
[32m+[m[32m| 📷 RGB-D Camera | Intel RealSense D435 | `fath_pivot_0_mount` | `camera_0` |[m
[32m+[m[32m| 📡 2D LiDAR | Hokuyo UST | `bracket_0_mount` | `lidar2d_0_laser` |[m
[32m+[m[32m| 🧭 IMU | Microstrain (default) | `base_link` | `imu_0_link` |[m
[32m+[m[32m| 🛰️ GPS | Novatel (default) | `base_link` | `gps_0_link` |[m
[32m+[m
[32m+[m[32m### TF Tree (요약)[m
[32m+[m[32m\`\`\`[m
[32m+[m[32mbase_link[m
[32m+[m[32m├── front_fender (sensor)[m
[32m+[m[32m├── rear_fender  (sensor)[m
[32m+[m[32m└── default_mount[m
[32m+[m[32m    └── ark_enclosure (= top_plate_link)[m
[32m+[m[32m        ├── bracket_0_mount       → Hokuyo UST[m
[32m+[m[32m        └── fath_pivot_0_mount    → RealSense D435[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 📁 디렉토리 구조[m
[32m+[m
[32m+[m[32m\`\`\`[m
[32m+[m[32msmartlab_project/[m
[32m+[m[32m├── smartlab_project_description/   # URDF, meshes[m
[32m+[m[32m│   ├── CMakeLists.txt[m
[32m+[m[32m│   ├── package.xml[m
[32m+[m[32m│   ├── meshes/[m
[32m+[m[32m│   └── urdf/[m
[32m+[m[32m│       └── smartlab_project_description.urdf.xacro[m
[32m+[m[32m├── smartlab_project_bringup/       # launch, config[m
[32m+[m[32m│   ├── CMakeLists.txt[m
[32m+[m[32m│   ├── package.xml[m
[32m+[m[32m│   ├── config/[m
[32m+[m[32m│   └── launch/[m
[32m+[m[32m│       └── smartlab_project_bringup.launch.py[m
[32m+[m[32m├── robot.yaml                      # Clearpath robot config[m
[32m+[m[32m├── README.md[m
[32m+[m[32m└── .gitignore[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## ⚙️ 시스템 요구사항[m
[32m+[m
[32m+[m[32m- Ubuntu 22.04 LTS[m
[32m+[m[32m- ROS 2 Humble Hawksbill[m
[32m+[m[32m- Gazebo Sim (Harmonic / Garden)[m
[32m+[m[32m- Clearpath ROS 2 packages[m
[32m+[m
[32m+[m[32m### 의존성 설치[m
[32m+[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32msudo apt update[m
[32m+[m[32msudo apt install -y \\[m
[32m+[m[32m  ros-humble-clearpath-simulator \\[m
[32m+[m[32m  ros-humble-clearpath-config \\[m
[32m+[m[32m  ros-humble-clearpath-generator-common \\[m
[32m+[m[32m  ros-humble-clearpath-viz \\[m
[32m+[m[32m  ros-humble-clearpath-nav2-demos[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 🚀 설치 및 실행[m
[32m+[m
[32m+[m[32m### 1. Workspace 준비[m
[32m+[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mmkdir -p ~/jackal_ws/src[m
[32m+[m[32mcd ~/jackal_ws/src[m
[32m+[m[32mgit clone https://github.com/year2eyo/smartlab_project.git[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m### 2. 빌드[m
[32m+[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mcd ~/jackal_ws[m
[32m+[m[32mcolcon build --symlink-install[m
[32m+[m[32msource install/setup.bash[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m### 3. robot.yaml 배치[m
[32m+[m
[32m+[m[32mClearpath는 \`~/clearpath/robot.yaml\`을 기본 설정 파일로 인식합니다.[m
[32m+[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mmkdir -p ~/clearpath[m
[32m+[m[32mln -sf ~/jackal_ws/src/smartlab_project/robot.yaml ~/clearpath/robot.yaml[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m### 4. 시뮬레이션 실행[m
[32m+[m
[32m+[m[32m**Terminal 1 — Gazebo:**[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mros2 launch clearpath_gz simulation.launch.py[m
[32m+[m[32m\`\`\`[m
[32m+[m[32m→ Gazebo 좌측 하단 ▶ play 버튼 클릭[m
[32m+[m
[32m+[m[32m**Terminal 2 — RViz:**[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mros2 launch clearpath_viz view_robot.launch.py namespace:=j100_0000[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m**Terminal 3 — 텔레옵 (선택):**[m
[32m+[m[32m\`\`\`bash[m
[32m+[m[32mros2 run teleop_twist_keyboard teleop_twist_keyboard \\[m
[32m+[m[32m  --ros-args -r cmd_vel:=/j100_0000/cmd_vel[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 📡 주요 ROS 2 토픽[m
[32m+[m
[32m+[m[32m| Topic | Type | Description |[m
[32m+[m[32m|---|---|---|[m
[32m+[m[32m| \`/j100_0000/cmd_vel\` | \`geometry_msgs/Twist\` | 속도 명령 입력 |[m
[32m+[m[32m| \`/j100_0000/platform/odom/filtered\` | \`nav_msgs/Odometry\` | EKF 필터링 오도메트리 |[m
[32m+[m[32m| \`/j100_0000/sensors/camera_0/color/image\` | \`sensor_msgs/Image\` | RGB 이미지 |[m
[32m+[m[32m| \`/j100_0000/sensors/camera_0/points\` | \`sensor_msgs/PointCloud2\` | RealSense 포인트클라우드 |[m
[32m+[m[32m| \`/j100_0000/sensors/lidar2d_0/scan\` | \`sensor_msgs/LaserScan\` | Hokuyo 2D 스캔 |[m
[32m+[m[32m| \`/j100_0000/sensors/imu_0/data\` | \`sensor_msgs/Imu\` | IMU 데이터 |[m
[32m+[m[32m| \`/j100_0000/sensors/gps_0/fix\` | \`sensor_msgs/NavSatFix\` | GPS Fix |[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 🛠 커스터마이징 가이드[m
[32m+[m
[32m+[m[32m### 센서 추가[m
[32m+[m[32m\`robot.yaml\`의 \`sensors\` 섹션에서 모델/위치/파라미터 수정.[m
[32m+[m[32m지원 모델 목록: [Sensors Documentation](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/sensors/overview)[m
[32m+[m
[32m+[m[32m### 커스텀 메쉬/링크 추가[m
[32m+[m[32m\`smartlab_project_description/urdf/smartlab_project_description.urdf.xacro\` 편집:[m
[32m+[m
[32m+[m[32m\`\`\`xml[m
[32m+[m[32m<link name="custom_link">[m
[32m+[m[32m  <visual>[m
[32m+[m[32m    <geometry>[m
[32m+[m[32m      <mesh filename="package://smartlab_project_description/meshes/custom.stl"/>[m
[32m+[m[32m    </geometry>[m
[32m+[m[32m  </visual>[m
[32m+[m[32m</link>[m
[32m+[m
[32m+[m[32m<joint name="custom_joint" type="fixed">[m
[32m+[m[32m  <parent link="base_link"/>[m
[32m+[m[32m  <child  link="custom_link"/>[m
[32m+[m[32m  <origin xyz="0 0 0.1" rpy="0 0 0"/>[m
[32m+[m[32m</joint>[m
[32m+[m[32m\`\`\`[m
[32m+[m
[32m+[m[32m### 커스텀 launch 추가[m
[32m+[m[32m\`smartlab_project_bringup/launch/\` 에 \`.launch.py\` 작성 후[m
[32m+[m[32m\`smartlab_project_bringup.launch.py\`에서 \`IncludeLaunchDescription\`으로 포함.[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 🗺️ 로드맵[m
[32m+[m
[32m+[m[32m- [x] Jackal J100 기본 시뮬레이션 환경 구축[m
[32m+[m[32m- [x] RealSense D435 + Hokuyo UST 통합[m
[32m+[m[32m- [ ] SmartLab 전용 Gazebo world (.sdf) 추가[m
[32m+[m[32m- [ ] SLAM 데모 (slam_toolbox)[m
[32m+[m[32m- [ ] Nav2 자율주행 통합[m
[32m+[m[32m- [ ] 커스텀 임무 launch 추가[m
[32m+[m[32m- [ ] 실기(real robot) 배포 가이드[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 📚 참고 자료[m
[32m+[m
[32m+[m[32m- [Clearpath ROS 2 Humble Documentation](https://docs.clearpathrobotics.com/docs/ros2humble/ros/)[m
[32m+[m[32m- [Robot YAML Overview](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/overview)[m
[32m+[m[32m- [Customization Package Guide](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/customization)[m
[32m+[m[32m- [J100 Attachments](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/platform/attachments/j100)[m
[32m+[m[32m- [Nav2 Tutorial](https://docs.clearpathrobotics.com/docs/ros2humble/ros/tutorials/navigation_demos/nav2)[m
[32m+[m
[32m+[m[32m---[m
[32m+[m
[32m+[m[32m## 👥 Maintainer[m
[32m+[m
[32m+[m[32m- **yeari** (year2eyo) — SmartLab[m
[32m+[m
[32m+[m[32m## 📝 License[m
[32m+[m
[32m+[m[32mBSD-3-Clause[m
