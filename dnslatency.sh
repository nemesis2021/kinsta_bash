curl -s -o /dev/null -w "google.com Total: %{time_total}s\n" https://google.com
curl -s -o /dev/null -w "facebook.com Total: %{time_total}s\n" https://facebook.com
curl -s -o /dev/null -w "msn.com Total: %{time_total}s\n" https://msn.com