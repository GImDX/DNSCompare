@echo off
setlocal enabledelayedexpansion

:: 切换到BIND文件夹
cd C:\Users\91571\Desktop\Software\BIND9.17.15.x64

:: 清空 DNS 缓存
echo Clearing DNS cache...
ipconfig /flushdns
if %errorlevel% neq 0 (
    echo Failed to clear DNS cache. Please run this script as Administrator.
    pause
    exit /b
)

:: 配置 DNS 服务器列表和目标域名
set "dns_servers=8.8.8.8 1.1.1.1 4.2.2.1 223.5.5.5 114.114.114.114 180.76.76.76 119.29.29.29"
set "target_domain=api.io.mi.com"

:: 输出表头
:: echo Testing DNS resolution speed for %target_domain%
:: echo --------------------------------------------
:: echo DNS Server        Query Time (ms)
:: echo --------------------------------------------

:: 遍历每个 DNS 服务器
::     set TEMP_FILE=C:\Users\91571\Desktop\Software\DNSCompare\temp.txt
:: for %%D in (%dns_servers%) do (
::     :: 使用 dig 查询域名，并提取查询时间
::     .\dig.exe @%%D %target_domain% +stats | findstr "msec" > %TEMP_FILE%
::     :: echo %TEMP_FILE%
::     set /p temp=<%TEMP_FILE%
::     :: echo !temp!
::     set  temp=!temp:~2!
::     :: echo !temp!
::     for /f "tokens=3" %%T in ( "!temp!") do (
::         set query_time=%%T
::     )
::     :: 打印结果
::     echo %%D              !query_time!
:: )

:: 配置 DNS 服务器和目标域名
set "dns_servers=8.8.8.8 1.1.1.1 4.2.2.1 223.5.5.5 114.114.114.114 180.76.76.76 119.29.29.29 112.100.100.100"
set "target_domains=api.io.mi.com www.google.com www.bing.com www.baidu.com www.taobao.com www.coinglass.com"

:: 输出表头
echo Testing DNS resolution speed
echo -------------------------------------------------------------------------------
echo DNS Server            Target Domain         Query Time (ms)       First Answer
echo -------------------------------------------------------------------------------

:: 遍历目标域名和 DNS 服务器
for %%T in (%target_domains%) do (
    for %%D in (%dns_servers%) do (
        :: 获取开始时间
        for /f %%S in ('bash -c "date +%%s%%3N"') do set start_time=%%S

        :: 执行 dig 命令，只获取 IP 地址
        for /f "delims=" %%I in ('.\dig.exe +short @%%D %%T') do set ip_address=%%I

        :: 获取结束时间
        for /f %%E in ('bash -c "date +%%s%%3N"') do set end_time=%%E

        :: 计算时间差
        set /a query_time=!end_time:~5!-!start_time:~5!

        :: 格式化输出
        set "dns_server=%%D"
        set "target_domain=%%T"
        set "padded_dns_server=!dns_server!                    "
        set "padded_dns_server=!padded_dns_server:~0,20!"
        set "padded_target_domain=!target_domain!                     "
        set "padded_target_domain=!padded_target_domain:~0,20!"
        set "padded_query_time=!query_time!                       "
        set "padded_query_time=!padded_query_time:~0,20!"

        echo !padded_dns_server!  !padded_target_domain!  !padded_query_time!  !ip_address!
    )
)

endlocal
