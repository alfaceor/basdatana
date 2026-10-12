#!/usr/bin/env bash
#
rclone bisync Papers/ gdrive:GitData/basdatana_Bibliography/Papers -v
rclone bisync Books/ gdrive:GitData/basdatana_Bibliography/Books -v

