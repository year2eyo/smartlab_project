"""
SmartLab 커스텀 월드로 Clearpath 시뮬레이션 실행하는 launch 파일.
시스템 심볼릭 링크 의존 없이 패키지 내부 worlds/ 폴더에서 SDF 로드.
"""

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, SetEnvironmentVariable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():
    # 패키지 경로
    pkg_smartlab_bringup = FindPackageShare('smartlab_project_bringup')

    # 월드 파일 경로 (패키지 내부)
    world_path = PathJoinSubstitution([
        pkg_smartlab_bringup, 'worlds', 'smart_lab'
    ])

    # Clearpath simulation.launch.py 경로
    clearpath_sim_launch = PathJoinSubstitution([
        FindPackageShare('clearpath_gz'),
        'launch',
        'simulation.launch.py'
    ])

    # 인자 선언
    use_sim_time = LaunchConfiguration('use_sim_time')
    setup_path = LaunchConfiguration('setup_path')
    rviz = LaunchConfiguration('rviz')
    x = LaunchConfiguration('x')
    y = LaunchConfiguration('y')
    yaw = LaunchConfiguration('yaw')

    return LaunchDescription([

        # 인자 정의
        DeclareLaunchArgument('use_sim_time', default_value='true'),
        DeclareLaunchArgument('setup_path', default_value='/home/yeari/clearpath/'),
        DeclareLaunchArgument('rviz', default_value='false'),
        DeclareLaunchArgument('x', default_value='0.0'),
        DeclareLaunchArgument('y', default_value='0.0'),
        DeclareLaunchArgument('yaw', default_value='0.0'),

        # GZ_SIM_RESOURCE_PATH에 우리 worlds/ 추가
        SetEnvironmentVariable(
            name='IGN_GAZEBO_RESOURCE_PATH',
            value=[
                PathJoinSubstitution([pkg_smartlab_bringup, 'worlds']),
                ':',
                PathJoinSubstitution([pkg_smartlab_bringup, 'models']),
            ]
        ),

        # Clearpath 시뮬레이션 launch 포함, world 인자에 절대경로 전달
        IncludeLaunchDescription(
            PythonLaunchDescriptionSource([clearpath_sim_launch]),
            launch_arguments={
                'world': world_path,
                'setup_path': setup_path,
                'rviz': rviz,
                'use_sim_time': use_sim_time,
                'x': x,
                'y': y,
                'yaw': yaw,
            }.items()
        ),
    ])
