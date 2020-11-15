from Bio import SeqIO
from os import listdir
from os.path import isfile, join
from os import getcwd


def sample_helper(fasta):
    return str(fasta.split("_")[0])


def parser(fasta, sample):
    newfasta = "renamed_" + fasta
    with open(newfasta, "w+") as nfa:
        with open(fasta, 'r') as contigs:
            for record in SeqIO.parse(contigs, "fasta"):
                head = record.id
                head = head.split()
                head = "".join(head)
                head_sample = ">{}_{}\n".format(sample, head)
                nfa.write("{}{}\n".format(head_sample, record.seq))


def path_file(mypath):
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    return onlyfiles


def extension_checker(onlyfiles, ext):
    fastafiles = []
    for file in onlyfiles:
        if file.endswith(ext):
            fastafiles.append(file)
    return fastafiles


def main():
    mypath = getcwd()
    onlyfiles = path_file(mypath)
    fastafiles = extension_checker(onlyfiles, ".fna")
    # fasta = "NTM01067_greater-1kb.phages_combined.faa"
    for fasta in fastafiles:
        print("Changing headers for {}".format(fasta))
        sample = sample_helper(fasta)
        print(sample)
        parser(fasta, sample)


if __name__ == '__main__':
    main()
