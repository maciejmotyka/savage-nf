# Calculate optimal split parameter for savage

def main():
    add_argument('--ref_len', dest='ref_len', type=int, help='length in bp of the sequenced genome to calculate --split parameter for savage')
    add_argument('-s', dest='input_s', type=str, help='path to input fastq containing single-end reads')
    add_argument('-p1', dest='input_p1', type=str, help='path to input fastq containing paired-end reads (/1)')
    add_argument('-p2', dest='input_p2', type=str, help='path to input fastq containing paired-end reads (/2)')

    # analyze single-end input reads
    if args.input_s:
        [s_total_len] = analyze_fastq(args.input_s)
    else:
        s_total_len = 0

    # analyze paired-end input reads
    if args.input_p1:
        [p1_total_len] = analyze_fastq(args.input_p1)
        [p2_total_len] = analyze_fastq(args.input_p2)
        p_total_len = p1_total_len + p2_total_len
        if p1_seq_count != p2_seq_count:
            sys.stderr.write("""ERROR: Unequal number of /1 and /2 reads. Exiting.\n""")
            sys.stderr.flush()
            sys.exit(1)

    total_seq_len = s_total_len + p_total_len
    if not total_seq_len > 0:
        sys.stderr.write("""ERROR: Total input length is zero. Exiting.\n""")
        sys.stderr.flush()
        sys.exit(1)

def analyze_fastq(filename):
    total_len = 0
    i = 0
    with open(filename) as f:
        for line in f:
            if i%4 == 1: # sequence line in fastq
                l = len(line.strip('\n'))
                total_len += l
            i += 1
        assert i % 4 == 0 # fastq
    return [total_len]

if __name__ == '__main__':
    sys.exit(main())
