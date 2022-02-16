split_pdf() {
    convert -density 300 "$1" \
            -alpha remove  \
            "$2"
}

xerox() {
    random_tilt=$(python gauss.py)
    convert "$1" -modulate 100,0 \
            \( +clone -blur 0x3 +level 10%x100% \) \
            +swap \
            -compose divide \
            -composite \
            -blur 0x1.5 \
            -rotate "$random_tilt" \
            -linear-stretch 5x0% \
            "$2"
}

join_pdf() {
    convert "$@" -quality 100 -units PixelsPerInch -density 72x72 output.pdf
}


split_pdf "$1" split-temp.jpg
for page in split-temp*; do
    xerox "$page" "${page/split/effect}"
done
join_pdf effect-temp*
