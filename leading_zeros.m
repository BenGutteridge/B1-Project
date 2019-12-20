function num_str = leading_zeros(num, dig)
num_str  = num2str(num);
len = size(num_str, 2);
if len < dig
    counter = dig - len;
    while counter > 0
        num_str = strcat('0', num_str);
        counter = counter - 1;
    end
elseif len > dig
    disp('Error: number has too many digits')
end
    

