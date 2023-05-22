def avg(nums) 
    sum = 0
    for i in 0..nums.length - 1 
        sum += nums[i]
    end

    return sum*1.0/nums.length
end

def main() 
    puts "Enter number of intergers: "
    n = gets.chomp.to_i()
    array = []
    for i in 0..n - 1
        puts "Enter number: "
        array.push(gets.chomp.to_i())
    end
    avg = avg(array)
    puts "Average is " + avg.to_s + "\n"
    if(avg >= 10) 
        puts "Double digits"
    else
        puts "Single digits"
    end
    gets
end

main()