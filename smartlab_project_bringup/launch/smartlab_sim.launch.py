"""
SmartLab 커스텀 월드로 Clearpath 시뮬레이션 실행.
IGN_GAZEBO_RESOURCE_PATH에 우리 models 폴더를 명시적으로 추가.
"""

import os
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, SetEnvironmentVariable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution, EnvironmentVariable
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():
    # 패키지 위치
    pkg_smartlab = get_package_share_dir()

    return LaunchDescription([
        # ⭐ 환경변수를 launch 시작 시점에 명시적으로 설정
        SetEnvironmentVariable(
            name='IGN_GAZEBO_RESOURCE_PATH',
            value=[
                os.environ.get('IGN_GAZEBO_RESOURCE_PATH', ''),
                ':',
                os.path.expanduser('~/jackal_ws/install/smartlab_project_bringup/share/smartlab_project_bringup/models'),
            ]
        ),

        DeclareLaunchArgument('use_sim_time', default_value='true'),
        DeclareLaunchArgument('setup_path', default_value='/home/yeari/clearpath/'),
        DeclareLaunchArgument('rviz', default_value='false'),
        DeclareLaunchArgument('x', default_value='0.0'),
        DeclareLaunchArgument('y', default_value='0.0'),
        DeclareLaunchArgument('yaw', default_value='0.0'),

        IncludeLaunchDescription(
            PythonLaunchDescriptionSource([
                PathJoinSubstitution([
                    FindPackageShare('clearpath_gz'),
                    'launch',
                    'simulation.launch.py'
                ])
            ]),
            launch_arguments={
                'world': PathJoinSubstitution([
                    FindPackageShare('smartlab_project_bringup'),
                    'worlds',
                    'smart_lab'
                ]),
                'setup_path': LaunchConfiguration('setup_path'),
                'rviz': LaunchConfiguration('rviz'),
                'use_sim_time': LaunchConfiguration('use_sim_time'),
                'x': LaunchConfiguration('x'),
                'y': LaunchConfiguration('y'),
                'yaw': LaunchConfiguration('yaw'),
            }.items()
        ),
    ])


def get_package_share_dir():
    """헬퍼"""
    from ament_index_python.packages import get_package_share_directory
    return get_package_share_directory('smartlab_project_bringup')
