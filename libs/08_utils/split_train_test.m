function [train, test] = split_train_test(dataset_size, train_size)

p = randperm(dataset_size);

train = p(1:floor(train_size*dataset_size));

test  = p(floor(train_size*dataset_size)+1:end);

end

