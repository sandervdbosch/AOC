module aoc2025::day2;
import std::io;
import std::time;
import std::math;

fn void main(String[] args){
    @pool(){
        Clock c = clock::now();
        io::printfn("Part1 answer: %d - completed in %s", part1(args[1]), c.mark());
        io::printfn("Part2 answer: %d - completed in %s", part2(args[1]), c.mark());
    };
}

fn long part1(String file){
    String[] data = ((String) file::load_temp(file)!!).tsplit(",");

    long result;

    foreach (range : data){
        String[] ranges = range.tsplit("-");
        long begin = ranges[0].to_long()!!;
        long end = ranges[1].to_long()!!;
        for (long i = begin; i <= end; ++i){
            if((long)(math::log(i, 10) + 1) % 2 == 0){
                if((i / (long)math::pow(10, (int)(math::log(i, 10) + 1) / 2)) == (i % (long)math::pow(10, (int)(math::log(i, 10) + 1) / 2))) result += i;
            }
        }
    }

    return result;
}

fn long part2(String file){
    String[] data = ((String) file::load_temp(file)!!).tsplit(",");

    long result;

    foreach(range : data){
        String[] ranges = range.tsplit("-");
        String begin = ranges[0];
        String end = ranges[1];
        if(end.len != begin.len){
            DString middle_end;
            DString middle_begin;
            for(usz i = 0; i < begin.len; ++i) middle_end.append_char('9');
            middle_begin.append_char('1');
            for(usz i = 1; i < end.len; ++i) middle_begin.append_char('0');
            result += check_range(begin, middle_end.str_view());
            result += check_range(middle_begin.str_view(), end);
            continue;
        }
        result += check_range(begin, end);
    }
    return result;
}

fn long check_range(String begin, String end){
    String current = begin;
    bool in_range = true;
    long result;

    while(in_range){
        if (current == end) in_range = false;
        result += evaluate_id(current);
        for(usz i = 1; i <= current.len; ++i){
            current[current.len - i]++;
            if(current[current.len - i] != '9' + 1) break;
            current[current.len - i] = '0';
        }
    }
    return result;
}

fn long evaluate_id(String id){
    for(usz i = 0; i < id.len / 2; ++i){
        if(id.len % (i + 1) == 0){
            for(usz j = 1; j < id.len / (i + 1); ++j){
                if (id[:(i + 1)] != id[j*(i + 1):(i + 1)]) break;
                if (j == id.len / (i + 1) - 1){
                    return id.to_long()!!;
                }
            }
        }
    }
    return 0;
}