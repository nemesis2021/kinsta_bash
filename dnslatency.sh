curl -s -o /dev/null -w "google.com Total: %{time_total}s\n" https://google.com
curl -s -o /dev/null -w "facebook.com Total: %{time_total}s\n" https://facebook.com
curl -s -o /dev/null -w "msn.com Total: %{time_total}s\n" https://msn.com

echo "--------------------"
echo Imagick Version:
grep mageMagickVersion /kinsta/main.conf && dpkg -l |grep imageMagickVersion=
echo "--------------------"

echo "--------------------"
echo Database:
echo "--------------------"
curl -s https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl | perl | awk '/General recommendations:/,/^$/'
