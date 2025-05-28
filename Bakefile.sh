

task.scan-duplex() {

    # assign date name automatically to second granularity. 4 zero padding
    # allows for thousands of names. Maybe minute granularity is enough. No, because
    # I want to be able to scan in small batches and can easily do more than one
    # batch within a minute.

    scanimage   --resolution 600 --format jpeg --batch=$(date -Is)-%04d.jpg --source "ADF Duplex"

    # This produces a strips from which the final photo must be cropped. How
    # to do this with imagemagick? Scan area is 5096x8693 pixels.
    # 8.49333 by 14.4883 in inches. This is at 600 dpi resolution.

}

task.scan-single() {
    # test this
    #scanimage --resolution 600 --format jpeg --batch=$(date -Is)-%04d.jpg --source "ADF"
    scanimage --resolution 600 --format jpeg --batch=$(date -Is)-%04d.jpg
}


task.inches2pix() {
    # 600 dpi
    dc -e "4k $1 600 * f"

}

task.calculate-x-offset() {
    # 600 dpi 
    dc -e "4k 5096 $1 600 * - 2 / f"

}

task.show-crop-args() {
cat<<EOT

portrait  4.375x3.5  --  2100x2625+1498+0 

landscape 4.375x3.5  --  2625x2100+1235.5+0

portrait  4.875x3.5  --  2100x2925+1498+0

landscape 4.875x3.5  --  2925x2100+1085.5+0

EOT
}

task.batch-crop() {
    if [ ! -d "cropped" ]
    then
        mkdir cropped
    fi

    for f in *.jpg; do
        convert "$f" -crop "$1" cropped/"$f"
    done
}


task.rotate() {
    # Rotate file $1 by $2 degrees
    convert "$1" -rotate "$2" tmp.jpg
}


task.exif() {
    # We need description and YYYY-MM as tag.
    # file = $1
    # description = $2
    # keywords = $3
    exiftool -xmp:description="$2" -iptc:keywords="$3" "$1"
}

