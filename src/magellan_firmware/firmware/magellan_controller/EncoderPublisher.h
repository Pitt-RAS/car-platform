#ifndef ENCODER_PUBLISHER_H
#define ENCODER_PUBLISHER_H

// constants for quik maffs
#define WHEEL_DIAMETER_METERS 0.10795       // meter
#define STEPS_PER_REV 6                 // 6 steps per full revolution of rotor
constexpr double GEAR_RATIO = 87 / 18;             // gear ratio (87 teeth on big gear / 18 teeth on small gear)
#define BIG_GEAR_TO_WHEEL_RATIO 3       // this accounts for the differential afaik

#include <ros.h>
#include <geometry_msgs/TwistWithCovarianceStamped.h>
#include <fsae_core/EncoderCount.h>
#include "Rate.h"

class EncoderPublisher {
public:
    EncoderPublisher(ros::NodeHandle& nh);
    void Update();
private:
    ros::NodeHandle& nh_;
    geometry_msgs::TwistWithCovarianceStamped twist_msg_;
    ros::Publisher velocity_publisher_;
    fsae_core::EncoderCount encoder_count_msg_;
    ros::Publisher encoder_count_publisher_;
    Rate update_rate_;
    Rate update_rate_debug_;
    double compute_distance(double steps);
    double compute_velocity(double delta);
};

#endif
