First Meet-Up, what we discussed
Mantra: Know types, know haskell, no types, no haskell

> import           Control.Concurrent
> import           Control.Monad
> import           Text.Read

Algebraic Data Types 
newtypes provide type safety with a runtime benefit, limited in that only one type can be used in a defintion
data types allow for multiple data constructors to be defined

> newtype StripeKey = StripeKey String
Example usage:
> stripeKey = StripeKey "secretKey"
Note: The above is safer than using plain strings since the compiler will enforce the type
> data MyNums = One | Two | Three 

What is a typeclass? A way to provide function overloading for Algebraic Data Types. 
If two data types implement (make an instance of) the same class, you can use the same function across both. 
A typeclass is conceptually similar to a Java interface. Classes can inherit from one another.

> class ToString a :: * where
>    to_str :: a -> String

Types have kinds. Kinds can be thought of as the type of types. 
What are kinds? Read Brent Yorgey's section on them here, "A brief digression on kinds":
http://www.cis.upenn.edu/~cis194/lectures/09-functors.html
Kinds will become important for us when we discuss monad transformers 
(a pre-req to programming with the Snap monad... or any web framework monad really).

Using typeclasses we can constrain our functions to only types that implement a certain typeclass. 
Example: 

> sayHey :: ToString a => a -> String
> sayHey x = to_str x ++ "hey"

> instance ToString MyNums where
>    to_str One = "one"
>    to_str Two = "two"
>    to_str Three = "three"

> instance Eq MyNums where
>    One == One = True
>    Two == Two = True
>    Three == Three = True
>    _ == _ = False

-- Still need to define (<=) instances
> instance Ord MyNums where
>    One < Two   = True
>    One < Three = True
>    Two < Three = True
>    _ < _ = False
>    a > b = not (a < b)

-- Quizzes
-- Define : ($) (.) foldr, foldl, map, filter

> ($) :: (a -> b) -> a -> b
> ($) f x = f x

> (.) :: (b -> c) -> (a -> b) -> a -> c
> (.) f g x = f (g x)

> foldr :: (a -> b -> b) -> b -> [a] -> b
> foldr _ y [] = y
> foldr f y (x:xs) = f x (foldr f y xs)

> foldl :: (a -> b -> a) -> a -> [b] -> a
> foldl f x xs = go x xs 
>       where
>          go z [] = z
>          go z (y:ys) = go (f z y) ys

> map :: (a -> b) -> [a] -> [b]
> map _ [] = []
> map f (x:xs) = f x : map f xs

> filter :: (a -> Bool) -> [a] -> [a]
> filter _ [] = []
> filter p (x:xs)
>     | p x       = x : filter p xs
>     | otherwise = filter p xs

Laziness
Expressions are only evaluated if they are absolutely needed, otherwise they are ignored.
By default haskell expressions are evaluated from othe outside in.
Laziness allows for the creation of infinite lists.

> example1 :: IO ()
> example1 = print $ [1,2,3,undefined] !! 2

> example2 :: IO ()
> example2 = print $ take 5 [1..]

IO () 
Getting command line input from the user, and printing it to screen, first interaction with a monad
-- :t getLine  :: IO String
-- :t putStrLn :: String -> IO ()
> main :: IO ()
> main = do
>     line <- getLine
>     putStrLn line

Identity Type, simplest data type, similar to a box
> data Identity a = Identity a

Maybe type, used for computations that may fail
> data Maybe a = Just a | Nothing

Example
> maybeExample :: IO ()
> maybeExample = do
>    line <- getLine
>    case readMaybe line :: Maybe Int of
>      Nothing  -> putStrLn "nothing"
>      Just num -> print num

Simple Concurrency
The main thread of execution (OS Thread) says "running" every three seconds
The forked thread of execution receives command line input and immediately writes it to the console (stdout)

> secs :: Int -> Int
> secs = (*1000000)

> concurrentProgramming :: IO ()
> concurrentProgramming = do
>  forkIO $ forever $ do
>         line <- getLine
>         putStrLn line
>  forever $ do
>         threadDelay (secs 2)
>         putStrLn "running..."

case statements
> isFun :: String -> Bool
> isFun thing = case thing of
>                 "sports" -> True
>                 "eating" -> True
>                  _       -> False

-- Function pattern matching
> isFun :: String -> Bool
> isFun "sports"   = True
> isFun "eating"   = True
> isFun _          = False

let - in statements
> addTwo = let a = 1
>              b = 1
>              c = a + b
>          in (+c)

where statements
> addFour = (+four)
>   where four = 4

Homework:

Read sections 1, 2 and 3 from the Typeclassopedia (up to functors) and do exercises.
http://www.haskell.org/haskellwiki/Typeclassopedia
Supplement this learning with 'Learn You a Haskell' section on Functors



