from subprocess import Popen, PIPE
from tqdm import tqdm


def scrub_values(v):
    v = v.replace('%', '').replace(' ', '')
    return v


def simple_bar(pct, ncols=60):
    parts = tqdm.format_meter(pct, 100, 100, ncols=ncols).split('|')
    parts[2] = ''
    return '|'.join(parts)


def smi_csv_read():
    fields = ["utilization.gpu", "utilization.memory", "memory.total",
              "memory.free", "memory.used"]
    cmd = "nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv,noheader".split(' ')
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE)
    proc.wait()
    gpus = []
    for line in proc.stdout.readlines():
        values = line.decode().strip().split(',')
        gpus.append({k: scrub_values(v) for (k,v) in zip(fields, values)})
    return gpus


def gpu_utilization_bar(gpu_dict):
    util_pct = int(gpu_dict['utilization.gpu'])
    return simple_bar(util_pct)


def print_gpu_bars():
    gpus = smi_csv_read()
    bars = [gpu_utilization_bar(gpu) for gpu in gpus]
    print(' '.join(bars))


if __name__ == '__main__':
    print_gpu_bars()
