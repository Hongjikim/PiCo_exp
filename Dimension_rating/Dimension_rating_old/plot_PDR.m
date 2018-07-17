data.trajectory_save{3,1}=data.trajectory_save{1,1};
for i = 2:16
    data.trajectory_save{3,i}=data.trajectory_save{1,i}+data.trajectory_save{3,i-1}(end);
end

for i = 1:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-327; end
for i = 2:2:16, data.trajectory_save{4,i}=data.trajectory_save{2,i}-655; end

plot(cat(1,data.trajectory_save{3,:}), -cat(1,data.trajectory_save{4,:}))