# smartlab_project

> Clearpath Jackal (J100) customization package for **SmartLab** environment.
> Based on Clearpath ROS 2 Humble framework with Gazebo Sim.

[![ROS 2](https://img.shields.io/badge/ROS_2-Humble-blue)](https://docs.ros.org/en/humble/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange)](https://releases.ubuntu.com/22.04/)
[![Gazebo](https://img.shields.io/badge/Gazebo-Sim-green)](https://gazebosim.org/)

---

## 📌 프로젝트 개요

본 패키지는 SmartLab 연구 환경에 맞춰 커스터마이징된 **Clearpath Jackal (J100)** ROS 2 설정 패키지입니다.
시뮬레이션과 실기 운용에 동일한 `robot.yaml` 구성을 사용하며, 향후 SmartLab 전용 환경(맵, 임무, 알고리즘)을 통합 관리합니다.

### 주요 목표
- ✅ Jackal J100 시뮬레이션 환경 구축
- ⏳ SmartLab 전용 Gazebo world 추가
- ⏳ 자율주행 (Nav2) 통합
- ⏳ 커스텀 임무 launch/config 작성

---

## 🤖 Robot Configuration

### Platform
- **Model**: Jackal J100
- **Battery**: HE2613 (S1P1)
- **Controller**: PS4
- **Top plate**: ARK Enclosure
- **Fenders**: Sensor type (front + rear)

### Sensors
| Type | Model | Mount | Frame ID |
|---|---|---|---|
| 📷 RGB-D Camera | Intel RealSense D435 | `fath_pivot_0_mount` | `camera_0` |
| 📡 2D LiDAR | Hokuyo UST | `bracket_0_mount` | `lidar2d_0_laser` |
| 🧭 IMU | Microstrain (default) | `base_link` | `imu_0_link` |
| 🛰️ GPS | Novatel (default) | `base_link` | `gps_0_link` |

### TF Tree (요약)
\`\`\`
base_link
├── front_fender (sensor)
├── rear_fender  (sensor)
└── default_mount
    └── ark_enclosure (= top_plate_link)
        ├── bracket_0_mount       → Hokuyo UST
        └── fath_pivot_0_mount    → RealSense D435
\`\`\`

---

## 📁 디렉토리 구조

\`\`\`
smartlab_project/
├── smartlab_project_description/   # URDF, meshes
│   ├── CMakeLists.txt
│   ├── package.xml
│   ├── meshes/
│   └── urdf/
│       └── smartlab_project_description.urdf.xacro
├── smartlab_project_bringup/       # launch, config
│   ├── CMakeLists.txt
│   ├── package.xml
│   ├── config/
│   └── launch/
│       └── smartlab_project_bringup.launch.py
├── robot.yaml                      # Clearpath robot config
├── README.md
└── .gitignore
\`\`\`

---

## ⚙️ 시스템 요구사항

- Ubuntu 22.04 LTS
- ROS 2 Humble Hawksbill
- Gazebo Sim (Harmonic / Garden)
- Clearpath ROS 2 packages

### 의존성 설치

\`\`\`bash
sudo apt update
sudo apt install -y \\
  ros-humble-clearpath-simulator \\
  ros-humble-clearpath-config \\
  ros-humble-clearpath-generator-common \\
  ros-humble-clearpath-viz \\
  ros-humble-clearpath-nav2-demos
\`\`\`

---

## 🚀 설치 및 실행

### 1. Workspace 준비

\`\`\`bash
mkdir -p ~/jackal_ws/src
cd ~/jackal_ws/src
git clone https://github.com/year2eyo/smartlab_project.git
\`\`\`

### 2. 빌드

\`\`\`bash
cd ~/jackal_ws
colcon build --symlink-install
source install/setup.bash
\`\`\`

### 3. robot.yaml 배치

Clearpath는 \`~/clearpath/robot.yaml\`을 기본 설정 파일로 인식합니다.

\`\`\`bash
mkdir -p ~/clearpath
ln -sf ~/jackal_ws/src/smartlab_project/robot.yaml ~/clearpath/robot.yaml
\`\`\`

### 4. 시뮬레이션 실행

**Terminal 1 — Gazebo:**
\`\`\`bash
ros2 launch clearpath_gz simulation.launch.py
\`\`\`
→ Gazebo 좌측 하단 ▶ play 버튼 클릭

**Terminal 2 — RViz:**
\`\`\`bash
ros2 launch clearpath_viz view_robot.launch.py namespace:=j100_0000
\`\`\`

**Terminal 3 — 텔레옵 (선택):**
\`\`\`bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard \\
  --ros-args -r cmd_vel:=/j100_0000/cmd_vel
\`\`\`

---

## 📡 주요 ROS 2 토픽

| Topic | Type | Description |
|---|---|---|
| \`/j100_0000/cmd_vel\` | \`geometry_msgs/Twist\` | 속도 명령 입력 |
| \`/j100_0000/platform/odom/filtered\` | \`nav_msgs/Odometry\` | EKF 필터링 오도메트리 |
| \`/j100_0000/sensors/camera_0/color/image\` | \`sensor_msgs/Image\` | RGB 이미지 |
| \`/j100_0000/sensors/camera_0/points\` | \`sensor_msgs/PointCloud2\` | RealSense 포인트클라우드 |
| \`/j100_0000/sensors/lidar2d_0/scan\` | \`sensor_msgs/LaserScan\` | Hokuyo 2D 스캔 |
| \`/j100_0000/sensors/imu_0/data\` | \`sensor_msgs/Imu\` | IMU 데이터 |
| \`/j100_0000/sensors/gps_0/fix\` | \`sensor_msgs/NavSatFix\` | GPS Fix |

---

## 🛠 커스터마이징 가이드

### 센서 추가
\`robot.yaml\`의 \`sensors\` 섹션에서 모델/위치/파라미터 수정.
지원 모델 목록: [Sensors Documentation](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/sensors/overview)

### 커스텀 메쉬/링크 추가
\`smartlab_project_description/urdf/smartlab_project_description.urdf.xacro\` 편집:

\`\`\`xml
<link name="custom_link">
  <visual>
    <geometry>
      <mesh filename="package://smartlab_project_description/meshes/custom.stl"/>
    </geometry>
  </visual>
</link>

<joint name="custom_joint" type="fixed">
  <parent link="base_link"/>
  <child  link="custom_link"/>
  <origin xyz="0 0 0.1" rpy="0 0 0"/>
</joint>
\`\`\`

### 커스텀 launch 추가
\`smartlab_project_bringup/launch/\` 에 \`.launch.py\` 작성 후
\`smartlab_project_bringup.launch.py\`에서 \`IncludeLaunchDescription\`으로 포함.

---

## 🗺️ 로드맵

- [x] Jackal J100 기본 시뮬레이션 환경 구축
- [x] RealSense D435 + Hokuyo UST 통합
- [ ] SmartLab 전용 Gazebo world (.sdf) 추가
- [ ] SLAM 데모 (slam_toolbox)
- [ ] Nav2 자율주행 통합
- [ ] 커스텀 임무 launch 추가
- [ ] 실기(real robot) 배포 가이드

---

## 📚 참고 자료

- [Clearpath ROS 2 Humble Documentation](https://docs.clearpathrobotics.com/docs/ros2humble/ros/)
- [Robot YAML Overview](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/overview)
- [Customization Package Guide](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/customization)
- [J100 Attachments](https://docs.clearpathrobotics.com/docs/ros2humble/ros/config/yaml/platform/attachments/j100)
- [Nav2 Tutorial](https://docs.clearpathrobotics.com/docs/ros2humble/ros/tutorials/navigation_demos/nav2)

---

## 👥 Maintainer

- **yeari** (year2eyo) — SmartLab

## 📝 License

BSD-3-Clause
