#!/bin/bash
wp core version && wp core verify-checksums;
wp option get siteurl && wp option get home;
