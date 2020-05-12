f=$(mktemp /dev/shm/bmp_XXXXXX.tmp)

rm test.tmp

x=$1
y=$2
m=$((
(( 4 - (( $x * 3 ) % 4 )) % 4 )
))

# hex to edian
function fout() {
t=$printf "%.$1x" $2
i=${#t}
while [ $i -gt 0 ]
do
i=$[$i-2]
printf ${t:$i:2} >> $f
done
}

function fout0(){
printf "%.$1x" $2 >> $f
}

function fout2(){
printf "%.2x" $1 >> $f
}

fout2 0x42
fout2 0x4d

fout0 8
fout0 8

fout 8 0x36
fout 8 0x28

fout 8 $x
fout 8 $y

fout 4 1
fout 4 0x18

fout0 8

fout 8 $(( 0x4 * $x * $y ))

fout 8 0
fout 8 0

fout0 8
fout0 8

# head out
cat $f | xxd -r -p > test.bmp
xxd -l 0x80 test.bmp
cat /dev/null > $file

echo

# data out
cat /dev/urandom | head -c $(( 3 * $x + $m ) * $y )) >> $f

xxd -l 0x80 $f
cat $f >> test.bmp

echo

xxd -l 0x80 test.bmp

rm $f



