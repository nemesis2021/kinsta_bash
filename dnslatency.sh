
echo "--------------------"
echo -e "\033[31mDNS Latency:\033[0m"
echo "--------------------"
curl -s -o /dev/null -w "google.com Total: %{time_total}s\n" https://google.com
curl -s -o /dev/null -w "facebook.com Total: %{time_total}s\n" https://facebook.com
curl -s -o /dev/null -w "msn.com Total: %{time_total}s\n" https://msn.com

echo "--------------------"
echo -e "\033[31mImagick Version:\033[0m"
grep mageMagickVersion /kinsta/main.conf && dpkg -l |grep imageMagickVersion=
find /usr/lib/php/*/ -name imagick.so -exec ls -lat {} \; | awk '{print $6, $7, $8, $9}'
echo "--------------------"

echo "--------------------"
echo -e "\033[31mDatabase:\033[0m"
echo "--------------------"
curl -s https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl | perl | awk '/General recommendations:/,/^$/'
