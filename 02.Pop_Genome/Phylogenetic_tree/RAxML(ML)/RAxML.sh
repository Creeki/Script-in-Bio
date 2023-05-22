#! /bin/bash
function usage() {
    echo "Usage: bash $0 --vcf <vcf> --outgroup <Outgroup> --output <output> --boot <bootstrap>--thread <Threads>"
    echo "required options"
      echo "-v|--vcf       vcf文件"
      echo "-O|--outgroup  外群名称，或是外群那个个体ID,若不设置，则无外群"
      echo "-o|--output    输出文件前缀"
      echo "-b|--boot      bootstrap次数，默认为100次"
      echo "-T|--thread    线程数，默认为20，吃CPU"
    exit 1;
}

vcf=""
outgroup=""
output=""
boot=100
thread=30

while [[ $# -gt 0 ]]
do 
  case "$1" in 
    -v|--vcf )
        vcf=$2 ; shift 2 ;;
    -O|--outgroup )
        outgroup=$2 ; shift 2 ;;
    -o|--output )
        output=$2 ; shift 2 ;;
    -b|--boot )
        boot=$2 ; shift 2 ;;
    -T|--thread )
        thread=$2 ; shift 2 ;;
    *) echo "Option errot!";
       usage
       shift
       ;;
   esac
done

if [ -z $vcf ] || [ -z $output ]; then 
    echo "Option --vcf and --outgroup and --output not specified" >&2
    usage
fi

function main() {
# 1、转为phy格式：
python /home/sll/software/vcf2phylip.py --input $vcf --output-prefix $output

# 2、建树：

if [[ -z $outgroup ]]; then
  raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMA -p 23 -x 123 -# $boot -s ${output}.min4.phy -n $output -T $thread -o $outgroup
else
  raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMA -p 23 -x 123 -# $boot -s ${output}.min4.phy -T $thread -o $outgroup
}
main
