#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

int removeDuplicates(int* nums,int numsSize)
{
    int i,j;
    for(i = 0;i < numsSize - 1 ;i++)
    {
        if(nums[i]==nums[i+1])
        {           
            for(j = i;j < numsSize - 2;j++)
            {
                nums[j+1] = nums[j+2];
            }
            numsSize = numsSize - 1;
        }
    }
    return i+1;
}

int maxProfit(int* prices,int priceSize)
{
    int sum = 0;
    for(int i = 0;i < priceSize - 1;i++)
    {
        if(prices[i]<prices[i+1])
        {
            sum = sum + prices[i+1] - prices[i];
        }
    }
    return sum;
}

void rotate(int* nums,int numsSize,int k)
{
    int tmp;
    for(;k > 0;k--)
    {   
        tmp = nums[numsSize - 1];
        for(int i = numsSize - 1;i > 0;i--)
        {
            nums[i] = nums[i-1];
        }
        nums[0] = tmp;
    }
}

bool containsDuplicate(int* nums,int numsSize)
{
    for(int i = 0;i < numsSize - 1;i++)
    {
        for(int j = i + 1;j < numsSize;j++)
        {
            if(nums[i]==nums[j])
                return true;
        }
    }
    return false;
}

int singleNumber(int* nums,int numsSize)
{
    int i,j;
    for(i = 0;i < numsSize;i++)
    {
        for(j = 0;j < numsSize;j++)
        {
            if(i == j)
                continue;
            if(nums[i]==nums[j])
                break;
        }
        if(j == numsSize)
            return nums[i];
    }
}

void sort(int* nums,int numsSize)
{
    int i,j,swap,maxlocation;
    for(i = 0;i < numsSize - 1;i++)
    {
        maxlocation = 0;
        for(j = 1;j < numsSize - i;j++)
        {   
            if(nums[maxlocation] < nums[j])
            {
                maxlocation = j;
            }
        }
        swap = nums[numsSize-1-i];
        nums[numsSize-1-i] = nums[maxlocation];
        nums[maxlocation] = swap;
    }
}

int* intersect(int* nums1,int nums1Size,int* nums2,int nums2Size,int* returnSize)
{
    int i,j = 0;
    *returnSize = 0;
    sort(nums1,nums1Size);
    sort(nums2,nums2Size);
    while(i < nums1Size&&j<nums2Size)
    {
        if(nums1[i] == nums2[j])
        {
            i++;
            j++;
            *returnSize = *returnSize + 1;
        }
        else if(nums1[i] < nums2[j])
        {
            i++;
        }
        else
        {
            j++;
        }
        
    }

void tremoveDuplicates()
{
    int i =0;
    int nums[]={1,2,2,3,3,4};
    printf("%d\n",removeDuplicates(nums,6));
    printf("\n\n");
    for (;i < removeDuplicates(nums,6) - 1;i++)
    {
        printf("%d\n",nums[i]);
    }
}

void tmaxProfit()
{
    int prices[] = {1,2,3,4,5};
    printf("%d\n",maxProfit(prices,5));
}

void trotate()
{
    int nums[] = {1,2,3,4,5,6,7};
    rotate(nums,7,3);
    for(int i = 0;i < 7;i++)
    {
        printf("%d ",nums[i]);
    }
}

void tcontainsDuplicate()
{
    int nums[] = {1,2,3,4,5};
    if(containsDuplicate(nums,5))
        printf("true\n");
    else
        printf("false\n");
}

void tsingleNumber()
{
    int nums[] = {3,4,4,3,5};
    printf("%d\n",singleNumber(nums,5));
}

void tsort()
{
    int a[] = {3,2,4,5};
    sort(a,4);
    for(int i = 0;i < 4;i++)
    {
        printf("%d\n",a[i]);
    }
}

int main()
{
    tsort();
    return 0 ;
}
