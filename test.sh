#!/bin/bash
# cloudflare-zone-checker.sh
#
# Description: 
#  The goal of this script is to confirm a domain's status on Cloudflare.
#  It should tell you if the domain is hosted anywhere on Cloudflare's network.
#
# Based on research done by Jenna R.
# Slack reference: https://kinsta.slack.com/archives/C01T75JBVTR/p1647440025278879?thread_ts=1638260881.258300&cid=C01T75JBVTR

DOMAIN="$1"
SUBDOMAIN="$2"

KINSTA_WP_IP="162.159.134.42"
REQUEST_INFO=$(curl -sIX GET -H "Host: $DOMAIN" "http://$KINSTA_WP_IP/")
STATUS_CODE=$(echo "$REQUEST_INFO" | head -n1 | awk '{print $2}')
NS_ZONE_COUNT=$(dig +short NS @jerry.ns.cloudflare.com "$DOMAIN" | wc -l)
KI_HEADER=$(echo "$REQUEST_INFO" | grep -o ki-edge | wc -l)


if [[ -n "$SUBDOMAIN" ]]; then
  REQUEST_INFO_SUBDOMAIN=$(curl -sIX GET -H "Host: $SUBDOMAIN" "http://$KINSTA_WP_IP/")
  STATUS_CODE_SUBDOMAIN=$(echo "$REQUEST_INFO_SUBDOMAIN" | head -n1 | awk '{print $2}')
  KI_HEADER_SUBDOMAIN=$(echo "$REQUEST_INFO_SUBDOMAIN" | grep -o ki-edge | wc -l)
fi

# Status code explanation
# [ ! ] Any non-409 status indicates a leftover CF component
# [ ! ] A 409 status indicates the domain isn't anywhere in CF's system yet

echo "[ ! ] Domain's status ..."
# Domain checks
if [[ "$STATUS_CODE" == "409" ]]; then
  echo "- $DOMAIN isn't on Cloudflare's system yet."
else
  echo "- $DOMAIN is present on Cloudflare's system."
  # The domain can be present in an old CF account, or in another SaaS provider
  # We can use the dig tool to try to find out.
  if [[ "$NS_ZONE_COUNT" -gt 0 ]]; then
    echo "- $DOMAIN has an active Cloudflare zone."
  else
    echo "- $DOMAIN (probably) has no active Cloudflare zone/account."
  fi
  if [[ "$KI_HEADER" -eq 1 ]]; then
    echo "- $DOMAIN is served by Kinsta."
  else
    echo "- $DOMAIN is not served by Kinsta."
  fi
fi


# Subdomain checks
if [[ -n "$SUBDOMAIN" ]]; then
  echo ""
  echo "[ ! ] Subdomain's status ..."

  if [[ "$STATUS_CODE_SUBDOMAIN" == "409" ]]; then
    echo "- $SUBDOMAIN isn't on Cloudflare's system yet."
  else  
    # Domain is present in CF's system, possibly in an active Cloudflare zone
    echo "- $SUBDOMAIN is present on Cloudflare's system."
    
    # BEING CF ZONE CHECKER
    if [[ "$NS_ZONE_COUNT" -gt 0 ]]; then
      echo "- $DOMAIN has an active Cloudflare zone/account."
      
      # Check if the subdomain is being served by 
      if [[ "$KI_HEADER_SUBDOMAIN" -eq 0 ]]; then
        echo "- $SUBDOMAIN is not served by Kinsta."
        echo "  This might indicate a conflict with an old active zone on Cloudflare, or a misconfigured subdomain."
      else
        echo "- $SUBDOMAIN is served by Kinsta."
        echo "  Everything should be working fine here."
      fi
    # Domain is present in CF's system, but there is no NS server available
    # This usually indicates a SaaS provider in use (for example: shopify)
    else
      echo "- $DOMAIN (probably) has no active Cloudflare zone/account."
      if [[ "$KI_HEADER_SUBDOMAIN" -eq 0 ]]; then
        echo "- $SUBDOMAIN is not served by Kinsta."
        echo "  This might indicate an old SaaS provider 'misdirecting' the traffic."
        echo "  The reverse-recovery method should work here."
      else
        echo "- $SUBDOMAIN is served by Kinsta."
        echo "  Everything should be working fine here."
      fi
    fi
    # END CF ZONE CHECKER


  fi
fi
